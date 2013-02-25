class StudentMajor < ActiveRecord::Base
  belongs_to :student
  belongs_to :major
  # attr_accessible :title, :body
end
