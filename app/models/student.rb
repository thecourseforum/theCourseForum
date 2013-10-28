class Student < ActiveRecord::Base
  has_many :majors, :through => :student_majors
  has_many :student_majors, :dependent => :destroy
  validates :grad_year, presence: true
  belongs_to :user
end
