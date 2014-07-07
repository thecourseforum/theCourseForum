class AddSemesterIdToSections < ActiveRecord::Migration
  def up
    add_column :sections, :semester_id, :integer

    Section.all.each do |s|
      if s.semester_id
        next
      end
      c = ActiveRecord::Base.connection.execute("SELECT * FROM course_semesters WHERE id = #{s.course_semester_id}").to_a.first
      if c
        s.course_id = c[1]
        s.semester_id = c[2]
        s.save
      end
    end

  end

  def down
    remove_column :sections, :semester_id
  end
end
