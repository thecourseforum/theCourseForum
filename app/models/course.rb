class Course < ActiveRecord::Base
  belongs_to :subdepartment
  has_many :course_semesters
  has_many :semesters, :through => :course_semesters
  has_many :sections, :through => :course_semesters
  has_many :professors, :through => :sections

  validates_presence_of :title, :course_number, :subdepartment

  def professors_list
    return self.professors.uniq{ |p| p.id }.sort_by{|p| p.last_name}
  end

  def mnemonic_number
    return "#{Subdepartment.find_by_id(self.subdepartment_id).mnemonic} #{self.course_number}"
  end

end
