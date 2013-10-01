class ErrorReportsController < ApplicationController

  def new
    @url = params[:url]
  end

  def submit
    ErrorReportMailer.error_report(params[:user_id], params[:report][:url], params[:report][:description]).deliver
    
    respond_to do |format|
      format.html { redirect_to params[:report][:url], notice: 'Error report successfully submitted! Thank you!' }
    end
  end

end