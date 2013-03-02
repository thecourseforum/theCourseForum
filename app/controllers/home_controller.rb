class HomeController < ApplicationController
  def index
  end
  def browse
  	@schools = School.all
  	@departments = Department.all
  end
end
