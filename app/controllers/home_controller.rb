class HomeController < ApplicationController
  def index
  	@user = User.new
  	@student = Student.new
  end
  def browse
  	@schools = School.all
  	@departments = Department.all
  end
end
