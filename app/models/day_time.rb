class DayTime < ActiveRecord::Base
  attr_accessible :day_time
  has_many_and_belongs_to :sections
end
