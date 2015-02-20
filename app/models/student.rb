class Student < ActiveRecord::Base
  belongs_to :user

  has_many :student_majors, :dependent => :destroy

  has_many :majors, :through => :student_majors

  validates :grad_year, presence: true
end
