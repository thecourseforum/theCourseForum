class Location < ActiveRecord::Base
  has_many_and_belongs_to :sections
end
