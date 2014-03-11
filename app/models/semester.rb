class Semester < ActiveRecord::Base
  has_many :courses, :through => :course_semesters

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
end
