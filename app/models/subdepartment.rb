class Subdepartment < ActiveRecord::Base
  has_and_belongs_to_many :departments
  has_many :courses
  has_many :professors, through: :courses

  validates_presence_of :name, :mnemonic
end
