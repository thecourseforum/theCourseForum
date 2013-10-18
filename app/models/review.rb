class Review < ActiveRecord::Base
  belongs_to :student
  belongs_to :semester
  belongs_to :course_professor
  belongs_to :course
  belongs_to :professor
  validates :comment, presence: true

  has_one :user, :through => :student

  # Get overall review rating from subcategories
  def overall
    ((professor_rating + enjoyability + recommend) / 3).round(2)
  end

end
