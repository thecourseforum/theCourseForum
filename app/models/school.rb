class School < ActiveRecord::Base
  has_many :departments

  validates_presence_of :name
end
