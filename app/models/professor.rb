class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :section_professors
  has_many :sections, :through => :section_professors
  has_many :course_semesters, :through => :sections
  has_many :courses, :through => :course_semesters

  def courses_list
    return self.courses.uniq_by{ |p| p.id }.sort_by{|p| p.subdepartment.mnemonic}
  end
end
