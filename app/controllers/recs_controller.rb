class RecsController < ApplicationController

  def courselist
    @courses = Course.all(:limit => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end
end
