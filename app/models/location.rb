class Location < ActiveRecord::Base
  attr_accessible :location
  has_many_and_belongs_to :sections
end
