class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :about, :terms, :privacy]
  skip_before_action :check_info, :only => [ :about, :terms, :privacy]  
end
