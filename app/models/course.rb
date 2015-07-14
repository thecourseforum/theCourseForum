class Course < ActiveRecord::Base
  belongs_to :subdepartment
  belongs_to :last_taught_semester, :class_name => Semester

  has_many :sections
  has_many :reviews
  has_many :books, -> { uniq }, :through => :sections
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
    self.book_requirements.where(:status => status).map{|r| r.book}.uniq
  end

  def units
    self.sections.select(:units).max.units.to_i
  end

  def self.offered(id)
    sections = Section.where(:semester_id => id)
    return Hash[sections.map{|section| [section.course_id, true]}]
  end


  def self.find_by_mnemonic_number(mnemonic, number)
    subdepartment = Subdepartment.includes(:courses).find_by(:mnemonic => mnemonic)
    if subdepartment
      subdepartment.courses.find_by(:course_number => number)
    else
      nil
    end
  end

  def self.update_last_taught_semester
    Course.includes(:sections).load.each do |course|
      number = course.sections.map(&:semester).uniq.compact.map(&:number).sort.last
      if number
        course.update(:last_taught_semester_id => Semester.find_by(:number => number).id)
      else
        puts "No sections with semesters for course ID: #{course.id}"
      end
    end
  end
end
