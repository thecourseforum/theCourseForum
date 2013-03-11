class HomeController < ApplicationController
  def index
  	@user = User.new
  	@student = Student.new
  	@professor = Professor.new
    @professors = Professor.all
  end

  def browse
  	@schools = School.all
  	@departments = Department.all
  end

  def create
  end

end
