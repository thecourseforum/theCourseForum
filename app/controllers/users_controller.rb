class UsersController < ApplicationController

  def settings
    @user = current_user
  end

end