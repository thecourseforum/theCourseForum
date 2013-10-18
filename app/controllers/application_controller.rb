class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :check_info

  def check_info
    if current_user
      if !(current_user.student || current_user.professor)
        if Professor.pluck(:email_alias).include?(current_user.email.split("@").first)
          redirect_to professor_sign_up_path
        else
          redirect_to student_sign_up_path
        end
      end
    end
  end

  def columnize(arr)
    [arr.shift((arr.length / 2).ceil), arr]
  end

  def search_url
    @search_url = "http://localhost:8983/solr/course_search?q="
  end
  
end
