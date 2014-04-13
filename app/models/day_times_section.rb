class DayTimesSection < ActiveRecord::Base
  belongs_to :day_time
  belongs_to :section
  belongs_to :location
end
