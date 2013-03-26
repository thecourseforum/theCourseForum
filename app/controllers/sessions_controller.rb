class SessionsController < ApplicationController
  skip_before_filter :check_login

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.old_authenticate(params[:password])
      @student = Student.find_by_user_id(@user.id)
      render "migrate"
    elsif @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to "/browse"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
