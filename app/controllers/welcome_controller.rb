class WelcomeController < ApplicationController
  def index
  	@student = Student.new
  	@user = User.new
  end
end
