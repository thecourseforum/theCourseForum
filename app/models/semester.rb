class Semester < ActiveRecord::Base
  has_many :sections
  has_many :grades

  has_many :courses, :through => :sections

  def self.current
    Semester.find_by(:year => 2016, :season => 'Fall')
  end

  def to_s
    "#{self.season} #{self.year}"
  end

  def self.get_number(params)
    num = 1090 + 10*(params[:semester_year].to_i - 2009)
      
    if params[:semester_season] == "January"
      num += 1
    elsif params[:semester_season] == "Spring"
      num += 2
    elsif params[:semester_season] == "Summer"
      num += 6
    elsif params[:semester_season] == "Fall"
      num += 8
    end

    return num
  end

  def self.now()
    current_date = Time.now

    month = current_date.month
    year = current_date.year
    day = current_date.day

    january_first = Time.new(current_date.year, 1, 1)
    may_first = Time.new(current_date.year, 5, 1)
    august_first = Time.new(current_date.year, 8, 1)

    end_of_j_term = 16
    graduation_day = 15
    start_of_fall_term = 28

    end_of_j_term -= january_first.wday
    graduation_day -= may_first.wday
    start_of_fall_term = start_of_fall_term - august_first.wday + 3

    if month == 1 and day < end_of_j_term
      return Semester.find_by(year: year, season: "January")
    elsif month < 5 or (month == 5 and day <= graduation_day)
      return Semester.find_by(year: year, season: "Spring")
    elsif month < 8 or (month == 8 and day <= start_of_fall_term)
      return Semester.find_by(year: year, season: "Summer")
    else
      return Semester.find_by(year: year, season: "Fall")
    end 

  end
end
