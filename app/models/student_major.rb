class StudentMajor < ActiveRecord::Base
  belongs_to :student
  belongs_to :major

  validates_uniqueness_of :major_id, :scope => :student_id
end
