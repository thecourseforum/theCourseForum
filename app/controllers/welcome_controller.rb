class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user != nil
      redirect_to '/browse'
      return
    end
    @user = User.new
  end
end
