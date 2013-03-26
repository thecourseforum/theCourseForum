class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_login

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def columnize(arr)
    [arr.shift((arr.length / 2).ceil), arr]
  end
  
  private
  def check_login
    if current_user == nil
      redirect_to root_url
    end
  end

  helper_method :current_user
end
