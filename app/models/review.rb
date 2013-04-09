class Review < ActiveRecord::Base
  belongs_to :CourseProfessor
  belongs_to :student
  belongs_to :semester
  belongs_to :course_professor
  attr_accessible :comment, :professor_rating, :enjoyability, :difficulty, :amount_reading, 
  	:amount_writing, :amount_group, :amount_homework, :only_tests, :recommend, :ta_name

  # Get overall review rating from subcategories
  def overall
    ((professor_rating + enjoyability + recommend) / 3).round(2)
  end
end
