class ContactUsController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :check_info

  def new
    @url = params[:url]
  end

  def submit
    if params[:report][:type] == nil
      ContactUsMailer.feedback2(params[:report][:email], params[:report][:description]).deliver

      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Sucessfully submitted! Thank you for your feedback!' }
      end
    end

    if params[:report][:type] == "problem"
      if params[:report][:anonymous] == "1"
        ContactUsMailer.error_report(nil, params[:report][:url], params[:report][:description]).deliver
      else
        ContactUsMailer.error_report(params[:user_id], params[:report][:url], params[:report][:description]).deliver
      end
      respond_to do |format|
        format.html { redirect_to params[:report][:url], notice: 'Error report successfully submitted! Thank you!' }
      end
    
    elsif params[:report][:type] == "feedback"
      if params[:report][:anonymous] == "1"
        ContactUsMailer.feedback(nil, params[:report][:description]).deliver
      else
        ContactUsMailer.feedback(params[:user_id], params[:report][:description]).deliver
      end

      respond_to do |format|
        format.html { redirect_to params[:report][:url], notice: 'Sucessfully submitted! Thank you for your feedback!' }
      end
    elsif params[:report][:type] == "other"
      ContactUsMailer.other(params[:user_id], params[:report][:description]).deliver

      respond_to do |format|
        format.html { redirect_to params[:report][:url], notice: 'Thank you for your feedback. We\'ll get back to you soon!'}
      end
    end

  end

end
