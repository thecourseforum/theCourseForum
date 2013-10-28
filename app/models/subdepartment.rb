class Subdepartment < ActiveRecord::Base
  has_and_belongs_to_many :department
  has_many :courses

  def professors_list
    profs = []
    self.courses.each do |course|
      profs += course.professors_list
    end

    return profs
  end
end
