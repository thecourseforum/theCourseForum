class Course < ActiveRecord::Base
  belongs_to :subdepartment
  has_many :sections
  has_many :section_professors, through: :sections
  has_many :semesters, :through => :sections
  has_many :professors, :through => :sections
  has_many :departments, through: :subdepartment
  has_many :reviews

  validates_presence_of :title, :course_number, :subdepartment

  def professors_list
    return self.professors.uniq{ |p| p.id }.sort_by{|p| p.last_name}
  end

  def mnemonic_number
    return "#{Subdepartment.find_by_id(self.subdepartment_id).mnemonic} #{self.course_number}"
  end

end
