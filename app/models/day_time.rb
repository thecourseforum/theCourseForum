class DayTime < ActiveRecord::Base
  has_and_belongs_to_many :sections

  def overlaps?(other_daytime)
    if day == other_daytime.day
      return (start_time.sub(':', '.').to_f < other_daytime.end_time.sub(':', '.').to_f and other_daytime.start_time.sub(':', '.').to_f < end_time.sub(':', '.').to_f)
    end
    return false
  end

end
