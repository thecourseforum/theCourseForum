class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :check_info

  def check_info
    if current_user
      if !(current_user.student) 
        redirect_to student_sign_up_path
      end
    end
  end

  def columnize(arr, n=2)
    val = []

    length = (arr.count / n).ceil

    (n-1).times do 
      val << arr.shift(length)
    end

    val << arr

    val
  end
  
end
