class Student < ActiveRecord::Base
  has_many :majors, :through => :student_majors
  has_many :student_majors, :dependent => :destroy
  belongs_to :user

  validates :grad_year, presence: true
end
