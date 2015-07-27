class Review < ActiveRecord::Base
  belongs_to :user, foreign_key: :student_id
  belongs_to :semester
  belongs_to :course
  belongs_to :professor

  #Can cast votes for reviews
  acts_as_voteable
  
  # validates :comment, presence: true

  after_create :update_stats
  after_destroy :update_stats

  validates_presence_of :student_id, :professor_rating, 
    :enjoyability, :difficulty, :recommend, :course_id, :professor_id

  validates :professor_rating, :enjoyability, :difficulty, :recommend, 
    :numericality => { :greater_than_or_equal_to => 1 }

  validates :amount_reading, :amount_writing, :amount_group, :amount_homework,
    :numericality => { :greater_than_or_equal_to => 0 }

  validates_uniqueness_of :student_id, :scope => [:course_id, :professor_id]

  # Get overall review rating from subcategories
  def overall
    ((professor_rating + enjoyability + recommend) / 3).round(2)
  end

  def update_stats
    course.stats.each(&:update_review_stats)
  end

end
