class Professor < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :sections
end
