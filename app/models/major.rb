class Major < ActiveRecord::Base
  has_many :students, :through => :student_majors

  validates_presence_of :name
end
