class Grade < ActiveRecord::Base
  belongs_to :section
  belongs_to :semester

  after_create :update_stats
  after_destroy :update_stats

  def self.mapping
    {
      aplus: 4.0,
      a: 4.0,
      aminus: 3.7,
      bplus: 3.3,
      b: 3.0,
      bminus: 2.7,
      cplus: 2.3,
      c: 2.0,
      cminus: 1.7,
      dplus: 1.3,
      d: 1.0,
      dminus: 0.7,
      f: 0.0
    }
  end

  def average
    counts = Grade.mapping.map { |letter, value|
      send("count_#{letter}".to_sym).times.map do
        value
      end
    }.flatten
    counts.length > 0 ? counts.instance_eval { sum / size.to_f } : nil
  end

  def update_stats
    section.course.update_gpa
  end
end
