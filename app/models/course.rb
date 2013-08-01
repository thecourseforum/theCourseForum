class Course < ActiveRecord::Base
  belongs_to :subdepartment
  has_many :course_semesters
  has_many :semesters, :through => :course_semesters
  has_many :sections, :through => :course_semesters
  has_many :professors, :through => :sections

  def professors_list
    return self.professors.uniq_by{ |p| p.id }.sort_by{|p| p.last_name}
  end

end
