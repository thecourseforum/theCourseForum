class HomeController < ApplicationController
  #todo not sure how best to share this code between here and department controller
  skip_before_filter :authenticate_user!, :only => [ :about, :terms, :privacy]
  skip_before_filter :check_info, :only => [ :about, :terms, :privacy]
  
  def index
    @user = User.new
    @student = Student.new
    @professor = Professor.new
    @professors = Professor.all
  end

  def browse
    @schools = School.all
    @departments = Department.all
    departments = Department.find(:all, :order => "name")
    schools = School.find(:all, :order => "name")
    artSchoolId = 1
    engrSchoolId = 2
    
    @artDeps = columnize(departments.select{|d| d.school_id == artSchoolId })
    @engrDeps = columnize(departments.select{|d| d.school_id == engrSchoolId })
    @otherSchools = columnize(schools.select{|s| s.id != artSchoolId && s.id != engrSchoolId })
  end
  
  def create
  end

end
