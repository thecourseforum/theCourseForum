class Student < ActiveRecord::Base
  has_many :majors, :through => :student_majors
  has_many :reviews
  validates :grad_year, presence: true
  belongs_to :user
end
