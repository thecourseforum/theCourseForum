class Course < ActiveRecord::Base
  belongs_to :subdepartment

  has_many :sections
  has_many :reviews
  has_many :books, :through => :sections
  has_many :book_requirements, :through => :sections

  has_and_belongs_to_many :users

  has_many :section_professors, :through => :sections
  has_many :semesters, :through => :sections
  has_many :professors, :through => :sections
  has_many :departments, through: :subdepartment

  validates_presence_of :title, :course_number, :subdepartment

  def professors_list
    self.professors.uniq{ |p| p.id }.sort_by{|p| p.last_name}
  end

  def mnemonic_number
    @mnemonic_number ||= "#{subdepartment.mnemonic} #{course_number}"
  end

  def book_requirements_list(status)
    self.book_requirements.where(:requirement_status => status).map{|r| r.book}.uniq
  end

  def units
    self.sections.select(:units).max.units.to_i
  end

  def self.find_by_mnemonic_number(mnemonic, number)
    subdepartment = Subdepartment.includes(:courses).find_by(:mnemonic => mnemonic)
    if subdepartment
      subdepartment.courses.find_by(:course_number => number)
    else
      nil
    end
  end

  def is_offered(year, season)
    section = self.sections
    if not section.nil?
      self.sections.each do |section|
        if not section.semester.nil?
          if section.semester.year == year and section.semester.season == season
            return true
          end
        end
      end
    end
    return false
  end

end
