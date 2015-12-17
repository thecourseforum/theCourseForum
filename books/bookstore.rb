require 'nokogiri'
require 'resolv-replace'

ActiveRecord::Base.logger.level = 1

log = File.open("#{Rails.root.to_s}/books/bookstore_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

# Monitor logging in real-time w/ tail -f
log.sync = true

initial_time = Time.now


puts 'Wiping book_requirements...'

semester_id = Semester.find_by(:season => 'Spring', :year => 2016).id

ActiveRecord::Base.connection.execute("DELETE br.* FROM book_requirements AS br JOIN sections AS s ON s.id=br.section_id WHERE s.semester_id=#{semester_id}")

headers = {
	:Referer => "http://www.uvabookstores.com/uvatext/",
}

departments = Nokogiri::Slop(RestClient.get('http://uvabookstores.com/uvatext/textbooks_xml.asp?control=campus&campus=77&term=108', headers)).departments.department
departments = [departments] if departments.class == Nokogiri::XML::Element

departments_queue = Queue.new
threads = []

departments.each_with_index do |department, index|
	departments_queue << department
end

# Preload all subdepartments and courses & professors
subdepartments = Subdepartment.includes(:courses).load
professors = Professor.all
books = Book.all

15.times do |index|
	threads[index] = Thread.new do
		while not departments_queue.empty?
			xml_department = departments_queue.pop
			mnemonic = xml_department['abrev']
			department_id = xml_department['id']

			subdepartment = subdepartments.find_by(:mnemonic => mnemonic)

			unless subdepartment
				log.puts "No Subdepartment: #{mnemonic}"
				next
			end

			puts "Parsing #{mnemonic}"

			courses = Nokogiri::Slop(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=department&dept=#{department_id}&term=108", headers)).courses.course
			courses = [courses] if courses.class == Nokogiri::XML::Element
			courses.each do |xml_course|
				course_number = xml_course['name']
				course_id = xml_course['id']

				course = subdepartment.courses.find_by(:course_number => course_number)

				unless course
					log.puts "No Course: #{mnemonic} #{course_number}"
					next
				end

				puts "Parsing #{mnemonic} #{course_number}"

				xml_sections = Nokogiri::Slop(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=course&course=#{course_id}&term=108", headers)).sections.section
				xml_sections = [xml_sections] if xml_sections.class == Nokogiri::XML::Element
				xml_sections.each do |xml_section|
					section_number = xml_section['name']
					section_id = xml_section['id']
					instructor_last_name = xml_section['instructor'].split(',').first
					prof_ids = professors.where(:last_name => instructor_last_name).pluck(:id)

					if section_number == "ALL"
						section_ids = course.sections.joins(:professors).where(:semester_id => semester_id, :professors => {:id => prof_ids}).distinct.pluck(:id)
					else
						section_ids = course.sections.where(:section_number => section_number, :semester_id => semester_id).distinct.pluck(:id)
					end

					unless section_ids
						log.puts "No Section: #{mnemonic} #{course_number} #{section_number}"
						next
					end

					books_raw = Nokogiri::HTML(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=section&section=#{section_id}", headers))

					books_raw = books_raw.css('.book.course-required') + books_raw.css('.course-pick.one') + books_raw.css('.book.course-recommended') + books_raw.css('.book.course-optional')

					books_raw.each_with_index do |book_info, index|
						new_price = book_info.css(".book-price-list").text.delete("$").to_f
						new_price = nil if new_price == 0
						used_price = book_info.css(".price").css("label").text.delete("$").to_f
						used_price = nil if used_price == 0

						isbn = book_info.css('.isbn').text
						title = book_info.css('.book-title').text
						author = book_info.css('.book-author').text
						# SPLITTING BY BLANK SPACE - IS NOT SPACE. ASCII CODE IS 160, NOT 32!!!!!!
						publisher = book_info.css('.book-publisher').text.split(' ').last
						edition = book_info.css('.book-edition').text.split(' ').last
						binding = book_info.css('.book-binding').text.split(' ').last

						isbn = isbn == '' ? nil : isbn

						if isbn
							book = books.find_by(:isbn => isbn)
						else
							# Stop duplicates, ex. "No Text - See Professor"
							book = books.find_by(:title => title)
						end

						if book
							book.update(
								:title => title,
								:author => author,
								:publisher => publisher,
								:edition => edition,
								:binding => binding,
								:bookstore_new_price => new_price,
								:bookstore_used_price => used_price
							)
						else
							begin
								book = Book.create(
									:title => title,
									:author => author,
									:publisher => publisher,
									:edition => edition,
									:binding => binding,
									:isbn => isbn,
									:bookstore_new_price => new_price,
									:bookstore_used_price => used_price
								)
							rescue Exception => e
								log.puts "Error while creating book: " + e.class.to_s
							end
						end

						section_ids.each do |section_id|
							begin
								BookRequirement.create(
									:book_id => book.id,
									:section_id => section_id,
									:status => book_info.css('.book-req').text
								)
							rescue Exception => e
								log.puts "Error while creating book_requirement: " + e.class.to_s
							end
						end
					end
				end
			end
		end
	end
end

threads.each do |thread|
	thread.join
end

puts "Finished parsing books in #{(Time.now - initial_time) / 60} minutes"

log.close