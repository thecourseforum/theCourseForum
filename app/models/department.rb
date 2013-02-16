class Department < ActiveRecord::Base
  attr_accessible :name, :prefix
  has_many :courses
end
