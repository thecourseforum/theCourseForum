require 'haml'
require 'haml/template/plugin'

class ErrorReportMailer < ActionMailer::Base
  default from: "error_reports@thecourseforum.com"

  def error_report(user_id, url, description)
    @user = User.find(user_id)
    @email = "tjd5at@virginia.edu"
    @url = url
    @description = description
    mail(to: @email, subject: 'Error Report from #{@user.email}')
  end
end
