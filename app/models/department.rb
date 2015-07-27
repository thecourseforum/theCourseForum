class Department < ActiveRecord::Base
  belongs_to :school

  has_many :professors

  has_and_belongs_to_many :subdepartments

  has_many :courses, :through => :subdepartments

  validates_presence_of :name
end
