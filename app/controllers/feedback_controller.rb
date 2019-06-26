#
# Handles FEEDBACK submission
#
class FeedbackController < ApplicationController
  skip_before_filter :authenticate_user!, only: :create
  before_action :verify_permission, only: [ :index, :show, :destroy ]
  
  # POST /feedback
  # receives data from `#feedbackData` in header.js
  def create
    @title = params[:title]
    @userEmail = params[:userEmail]
    @description = params[:description]
    
    FeedbackMailer.feedback(@title, @userEmail, @description).deliver_now
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Sucessfully submitted! Thank you for your feedback!' }
    end
  end
  
  def verify_permission
    if !current_user
      head :unauthorized and return
    end
  end
end
