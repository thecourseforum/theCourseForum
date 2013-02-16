class Course < ActiveRecord::Base
  attr_accessible :title, :number
  belongs_to :department
  has_many :professors
end
