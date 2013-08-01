class StudentMajor < ActiveRecord::Base
  belongs_to :student
  belongs_to :major
end
