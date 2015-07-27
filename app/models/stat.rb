class Stat < ActiveRecord::Base
  belongs_to :course
  belongs_to :professor

  def update_gpa
    if professor
      averages = course.section_professors.includes(:section => :grades).where(:professor_id => professor.id).map(&:section).flat_map(&:grades).map(&:average).compact
    else
      averages = course.grades.map(&:average).compact
    end
    if averages.count != 0
      update(:gpa => averages.instance_eval { sum / size.to_f })
    end
  end

  def update_review_stats
    if professor
      reviews = course.reviews.where(:professor_id => professor.id)
    else
      reviews = course.reviews
    end
    puts id
    if reviews.count > 0
      update(
        :difficulty => reviews.pluck(:difficulty).instance_eval { sum / size.to_f },
        :rating => reviews.pluck(:professor_rating, :enjoyability, :recommend).flatten.map(&:to_f).instance_eval { sum / size.to_f }
      )
    end
  end

  def self.update_review_stats
    self.all.each(&:update_review_stats)
  end
end