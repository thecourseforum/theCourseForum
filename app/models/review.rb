class Review < ActiveRecord::Base
  belongs_to :user, foreign_key: :student_id
  belongs_to :semester
  belongs_to :course_professor
  belongs_to :course
  belongs_to :professor

  #Can cast votes for reviews
  acts_as_voteable
  
  # validates :comment, presence: true

  validates_presence_of :student_id, :professor_rating, 
    :enjoyability, :difficulty, :recommend, :course_id, :professor_id

  validates_uniqueness_of :student_id, :scope => [:course_id, :professor_id]

  # Get overall review rating from subcategories
  def overall
    ((professor_rating + enjoyability + recommend) / 3).round(2)
  end

end
