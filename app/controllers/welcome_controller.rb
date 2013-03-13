class WelcomeController < ApplicationController
  def index
  	@student = Student.new
  	@user = User.new
  	@professor = Professor.new
  end
end
