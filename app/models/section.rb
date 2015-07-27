class Section < ActiveRecord::Base
  belongs_to :semester
  belongs_to :course

  has_many :section_professors, :dependent => :destroy
  has_many :grades, :dependent => :destroy
  has_many :day_times_sections, :dependent => :destroy
  has_many :book_requirements, :dependent => :destroy

  has_and_belongs_to_many :schedules

  has_many :professors, :through => :section_professors
  has_many :day_times, :through => :day_times_sections
  has_many :locations, :through => :day_times_sections
  has_many :books, :through => :book_requirements, :source => :book

  def conflicts?(other_section)
    day_times.each do |day_time|
      other_section.day_times.each do |other_day_time|
        if day_time.overlaps?(other_day_time)
          return true
        end
      end
    end
    return false
  end

end
