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
    if reviews.count > 0
      update(
        :difficulty => reviews.pluck(:difficulty).instance_eval { sum / size.to_f },
        :rating => reviews.pluck(:professor_rating, :enjoyability, :recommend).flatten.map(&:to_f).instance_eval { sum / size.to_f }
      )
    end
  end

  def update_stats
    update_review_stats
    update_gpa
  end

  def self.update_review_stats
    initial_time = Time.now
    stats = self.all
    stats.each_with_index do |stat, index|
      puts "#{(index / stats.size.to_f * 100).round(2)}%"
      stat.update_review_stats
    end
    puts "Completed in #{Time.now - initial_time} seconds"
  end

  def self.update_gpa
    initial_time = Time.now
    stats = self.all
    stats.each_with_index do |stat, index|
      puts "#{(index / stats.size.to_f * 100).round(2)}%"
      stat.update_gpa
    end
    puts "Completed in #{Time.now - initial_time} seconds"
  end

  def self.update_all
    initial_time = Time.now
    stats = self.all
    stats.each_with_index do |stat, index|
      puts "#{(index / stats.size.to_f * 100).round(2)}%"
      stat.update_stats
    end
    puts "Completed in #{Time.now - initial_time} seconds"
  end

end