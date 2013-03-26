class WelcomeController < ApplicationController
  skip_before_filter :check_login
  def index
    if current_user != nil
      redirect_to '/browse'
      return
    end
    @student = Student.new
    @user = User.new
    @professor = Professor.new
  end
end
