class Section < ActiveRecord::Base
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
  has_many :day_times_sections
  has_many :day_times, :through => :day_times_sections
  has_many :locations, :through => :day_times_sections
  belongs_to :semester
  belongs_to :course
  belongs_to :location
  belongs_to :day_time

  has_and_belongs_to_many :users

  def conflicts?(other_section)
    day_times.each do |day_time|
      other_section.day_times do |other_day_time|
        if day_time.overlaps?(other_day_time)
          return true
        end
      end
    end
    return false
  end

end
