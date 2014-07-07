#!/usr/bin/env ruby

require 'net/http'

def merge_professors
  professors = Professor.all

  uniq_profs = Set.new
  duplicate_profs = []

  professors.each do |p|
    if not uniq_profs.add? p.full_name
      duplicate_profs.push(p.full_name)
    end
  end

  duplicate_profs.sort!.each do |full_name|
    name = full_name.split(" ")
    professor_list = Professor.where(first_name: name[0], last_name: name[1]).to_a

    while professor_list.count > 1
      p1 = professor_list[0]
      p2 = professor_list[1]

  # end

  # professors.each do |p1|
  #   professors.each do |p2|
      if p1.full_name == p2.full_name and p1.id != p2.id

        puts
        puts "**********"

        # possible duplicate professor
        p1_courses = p1.courses.uniq
        p1_subdepartments = Set.new
        p1_departments = Set.new
        puts "| #{p1.id} | #{p1.full_name} | #{p1.email_alias} | #{p1.created_at}"
        puts "Courses: "
        for course in p1_courses.sort_by{|c| [c.mnemonic_number]}
          print course.mnemonic_number + ", "
          # puts "\t#{course.mnemonic_number} | #{Semester.where(id: Section.where( id: SectionProfessor.where(section_id:course.sections.pluck(:id), professor_id: p1.id).pluck(:section_id)).pluck(:semester_id)).pluck(:number).uniq}"
          p1_subdepartments.add(course.subdepartment_id)
          p1_departments.add(course.subdepartment.departments.pluck(:id))
        end

        puts "\n-----"

        p2_courses = p2.courses.uniq
        p2_subdepartments = Set.new
        p2_departments = Set.new
        puts "| #{p2.id} | #{p2.full_name} | #{p2.email_alias} | #{p2.created_at}"
        puts "Courses: "
        for course in p2_courses.sort_by{|c| [c.mnemonic_number]}
          print course.mnemonic_number + ", "
          p2_subdepartments.add(course.subdepartment_id)
          p2_departments.add(course.subdepartment.departments.pluck(:id))
        end

        puts "\n-----"

        html = Net::HTTP.get(URI("http://rabi.phys.virginia.edu/mySIS/CS2/ldap.php?Name=#{p1.first_name}%20#{p1.last_name}"))

        print "Alias: "

        if html.downcase.include? "multiple"
          puts "Multiple"
        elsif html.downcase.include? "could not be located"
          puts "Could not be found"
        else
          puts "Single"
        end

        puts "-----"

        print "Likely these are the same professor?: "

        if p1.courses.to_set.subset? p2.courses.to_set or p2.courses.to_set.subset? p1.courses.to_set
          puts "Almost definitely"
        elsif p1.email_alias != nil and p2.email_alias != nil and p1.email_alias != p2.email_alias
          puts "No"
        elsif p1_subdepartments.subset? p2_subdepartments or p2_subdepartments.subset? p1_subdepartments
          puts "Yes"
        elsif p1_departments.subset? p2_departments or p2_departments.subset? p1_departments
          puts "Maybe"
        else
          puts "Possibly Not"
        end

        puts "-----"

        going_to_merge = ""

        while not (going_to_merge == "yes" or going_to_merge == "no" or going_to_merge == "courses")
          print "Want to merge? (yes/no/courses): "
          going_to_merge = gets.chomp.downcase
        end

        if going_to_merge == "yes"
          id_to_keep = 0

          while not (id_to_keep == p1.id or id_to_keep == p2.id)
            print "Select id of object to keep (#{p1.id}/#{p2.id}): "
            id_to_keep = gets.chomp.to_i
          end

          if id_to_keep == p1.id
            professor_to_destroy = p2
            professor_to_keep = p1
          else
            professor_to_destroy = p1
            professor_to_keep = p2
          end

          total_sections = p1.sections + p2.sections

          old_prof_reviews = Review.where(professor_id: professor_to_destroy.id)

          professor_to_keep.sections = total_sections

          professor_to_keep.save

          for review in old_prof_reviews
            review.professor_id = professor_to_keep.id
            review.save
          end


          professor_to_destroy.destroy

          professor_list = Professor.where(first_name: name[0], last_name: name[1]).to_a
        elsif going_to_merge == "courses"
          all_courses = (p1_courses + p2_courses).uniq.sort

          puts
          puts "Assigning Courses:"

          for course in all_courses
            puts course.mnemonic_number

            id_to_keep = 0

            while not (id_to_keep == p1.id or id_to_keep == p2.id)
              print "Select id of prof to assign (#{p1.id}/#{p2.id}): "
              id_to_keep = gets.chomp.to_i
            end

            if id_to_keep == p1.id
              professor_to_destroy = p2
              professor_to_keep = p1
            else
              professor_to_destroy = p1
              professor_to_keep = p2
            end
            #find all sections for course, where 
            sections_to_assign = Section.where(id: course.section_professors.where(professor_id: professor_to_destroy.id).pluck(:section_id))

            professor_to_keep.sections += sections_to_assign

            reviews_to_assign = course.reviews.where(professor_id: professor_to_destroy.id)

            for review in reviews_to_assign
              review.professor_id = professor_to_keep.id
              review.save
            end

            course.section_professors.where(professor_id: professor_to_destroy.id).destroy_all
          end
          professor_list = Professor.where(first_name: name[0], last_name: name[1]).to_a
        else
          if professor_list.count == 2
            professor_list -= [p2]
          else
            id_to_keep = 0

            while not (id_to_keep == p1.id or id_to_keep == p2.id)
              print "Select id of prof to skip (#{p1.id}/#{p2.id}): "
              id_to_keep = gets.chomp.to_i
            end

            if id_to_keep == p1.id
              professor_to_destroy = p1
              professor_to_keep = p2
            else
              professor_to_destroy = p2
              professor_to_keep = p1
            end

            professor_list -= [professor_to_destroy]
          end
        end


        puts "**********"
        puts
      end
    end
  end
end

merge_professors