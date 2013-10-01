class ErrorReportsController < ApplicationController

  def new
    @url = params[:url]
  end

  def submit
    ErrorReportMailer.error_report(params[:user_id], params[:report][:url], params[:report][:description]).deliver
    redirect_to params[:report][:url]
  end

end