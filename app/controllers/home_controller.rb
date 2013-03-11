class HomeController < ApplicationController
  #todo not sure how best to share this code between here and department controller
  def index
  	departments = Department.find(:all, :order => "name")
    schools = School.find(:all, :order => "name")
    artSchoolId = 1
    engrSchoolId = 2

    @artDeps = columnize(departments.select{|d| d.school_id == artSchoolId })
    @engrDeps = columnize(departments.select{|d| d.school_id == engrSchoolId })
    @otherSchools = columnize(schools.select{|s| s.id != artSchoolId && s.id != engrSchoolId })
  end
end
