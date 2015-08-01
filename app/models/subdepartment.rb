class Subdepartment < ActiveRecord::Base
  has_many :courses
  has_many :professors, through: :courses

  has_and_belongs_to_many :departments

  validates_presence_of :name, :mnemonic
end
