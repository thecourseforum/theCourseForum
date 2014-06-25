class AddSemesterIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :semester_id, :integer

    Section.all.each do |s|
      c = ActiveRecord::Base.connection.execute("SELECT * FROM course_semesters WHERE id = #{s.course_semester_id}").to_a
      s.semester_id = c[2]
      s.save
    end

  end
end
