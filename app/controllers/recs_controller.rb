class RecsController < ApplicationController

  def courselist
    @courses = Course.all.sample(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end
end
