#!/usr/bin/env ruby

def merge_professors
  professors = Professor.all

  professors.each do |p1|
    professors.each do |p2|
      if p1.full_name == p2.full_name and p1.id != p2.id

        puts "**********"

        # possible duplicate professor
        p1_courses = p1.courses
        p1_subdepartments = Set.new
        p1_departments = Set.new
        puts "| #{p1.id} | #{p1.full_name} | #{p1.email_alias}"
        puts "Courses: "
        for course in p1_courses
          print course.mnemonic_number + ", "
          p1_subdepartments.add(course.subdepartment_id)
          p1_departments.add(course.subdepartment.departments.pluck(:id))
        end

        puts "\n-----"

        p2_courses = p2.courses
        p2_subdepartments = Set.new
        p2_departments = Set.new
        puts "| #{p2.id} | #{p2.full_name} | #{p2.email_alias}"
        puts "Courses: "
        for course in p2_courses
          print course.mnemonic_number + ", "
          p2_subdepartments.add(course.subdepartment_id)
          p2_departments.add(course.subdepartment.departments.pluck(:id))
        end

        puts "\n-----"

        print "Likely these are the same professor?: "

        if p1.email_alias != nil and p2.email_alias != nil and p1.email_alias != p2.email_alias
          print "No\n"
        elsif p1_subdepartments.subset? p2_subdepartments or p2_subdepartments.subset? p1_subdepartments
          print "Yes\n"
        elsif p1_departments.subset? p2_departments or p2_departments.subset? p1_departments
          print "Maybe\n"
        else
          print "Probably Not\n"
        end

        puts "-----"

        going_to_merge = ""

        while not (going_to_merge == "yes" or going_to_merge == "no")
          print "Want to merge? (yes/no): "
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
        end
      end
    end
  end
end

merge_professors