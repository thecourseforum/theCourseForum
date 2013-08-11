class DayTime < ActiveRecord::Base
  has_and_belongs_to_many :sections
end
