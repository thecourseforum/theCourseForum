class Section < ActiveRecord::Base
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
  has_many :day_times_sections
  has_many :day_times, :through => :day_times_sections
  has_many :locations, :through => :day_times_sections
  belongs_to :semester
  belongs_to :course
  has_many :section_users
  has_many :users, :through => :section_users
  belongs_to :location
  belongs_to :day_time
end
