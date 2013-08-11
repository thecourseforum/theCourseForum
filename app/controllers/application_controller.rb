class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def columnize(arr)
    [arr.shift((arr.length / 2).ceil), arr]
  end

  def search_url
    @search_url = "http://localhost:8983/solr/course_search?q="
  end
  
end
