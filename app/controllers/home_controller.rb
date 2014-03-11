class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :about, :terms, :privacy]
  skip_before_filter :check_info, :only => [ :about, :terms, :privacy]  
end
