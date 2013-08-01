class Professor < ActiveRecord::Base
  belongs_to :department
  belongs_to :user
  has_many :section_professors
  has_many :sections, :through => :section_professors
  has_many :course_semesters, :through => :sections
  has_many :courses, :through => :course_semesters
end
