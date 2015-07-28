require 'nokogiri'

# ActiveRecord::Base.logger.level = 1

log = File.open("#{Rails.root.to_s}/books/bookstore_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

initial_time = Time.now


puts 'Wiping book_requirements...'

semester_id = Semester.find_by(:season => 'Fall', :year => 2015)

Semester.includes(:sections => :book_requirements).find(semester_id).sections.flat_map(&:book_requirements).map(&:delete)

headers = {
	:Referer => "http://www.uvabookstores.com/uvatext/",
}

departments = Nokogiri::Slop(RestClient.get('http://uvabookstores.com/uvatext/textbooks_xml.asp?control=campus&campus=77&term=92', headers)).departments.department
departments = [departments] if departments.class == Nokogiri::XML::Element
departments.each do |xml_department|
	mnemonic = xml_department['abrev']
	department_id = xml_department['id']

	subdepartment = Subdepartment.find_by(:mnemonic => mnemonic)

	unless subdepartment
		log.puts "No Subdepartment: #{mnemonic}"
		next
	end

	puts "Parsing #{mnemonic}"

	courses = Nokogiri::Slop(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=department&dept=#{department_id}&term=92", headers)).courses.course
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

		sections = Nokogiri::Slop(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=course&course=#{course_id}&term=92", headers)).sections.section
		sections = [sections] if sections.class == Nokogiri::XML::Element
		sections.each do |xml_section|
			section_number = xml_section['name']
			section_id = xml_section['id']

			section = course.sections.find_by(:section_number => section_number, :semester => semester_id)

			unless section
				log.puts "No Section: #{mnemonic} #{course_number} #{section_number}"
				next
			end

			Nokogiri::HTML(RestClient.get("http://uvabookstores.com/uvatext/textbooks_xml.asp?control=section&section=#{section_id}", headers)).css('.book.course-required').each_with_index do |book_info, index|
				# new_price = nil
				# new_data = book_info.css(".tr-radio-sku")[0]
				# unless new_data.css('input').first["disabled"]
				# 	new_price = new_data.css(".price").text.gsub(/[^\d\.]/, '').to_f
				# 	new_
				# end
				# used_price = nil
				# used_data = book_info.css(".tr-radio-sku")[1]
				# unless used_data.css('input').first["disabled"]
				# 	used_price = used_data.css(".price").text.gsub(/[^\d\.]/, '').to_f
				# end

				new_price = book_info.css(".book-price-list").text.delete("$").to_f
				new_price = nil if new_price == 0
				used_price = book_info.css(".price").css("label").text.delete("$").to_f
				used_price = nil if used_price == 0

				isbn = book_info.css('.isbn').text

				isbn = isbn == '' ? nil : isbn

				book = isbn ? Book.find_by(:isbn => isbn) : nil

				if book
					book.update(
						:title => book_info.css('.book-title').text,
						:author => book_info.css('.book-author').text,
						# SPLITTING BY BLANK SPACE - IS NOT SPACE. ASCII CODE IS 160, NOT 32!!!!!!
						:publisher => book_info.css('.book-publisher').text.split(' ').last,
						:edition => book_info.css('.book-edition').text.split(' ').last,
						:binding => book_info.css('.book-binding').text.split(' ').last,	
						:bookstore_new_price => new_price,
						:bookstore_used_price => used_price
					)
				else
					book = Book.create(
						:title => book_info.css('.book-title').text,
						:author => book_info.css('.book-author').text,
						# SPLITTING BY BLANK SPACE - IS NOT SPACE. ASCII CODE IS 160, NOT 32!!!!!!
						:publisher => book_info.css('.book-publisher').text.split(' ').last,
						:edition => book_info.css('.book-edition').text.split(' ').last,
						:binding => book_info.css('.book-binding').text.split(' ').last,
						:isbn => isbn,
						:bookstore_new_price => new_price,
						:bookstore_used_price => used_price
					)
				end

				BookRequirement.create(
					:book_id => book.id,
					:section_id => section.id,
					:status => book_info.css('.book-req').text
				)
			end
		end
	end
end

puts "Finished parsing books in #{(Time.now - initial_time) / 60} minutes"

log.close