require 'haml'
require 'haml/template/plugin'

class ContactUsMailer < ActionMailer::Base
  default from: "support@thecourseforum.com"

  def error_report(user_id, url, description)
    @user = (user_id != nil ? User.find(user_id) : nil)
    @email = "tjd5at@virginia.edu"
    @url = url
    @description = description
    mail(to: @email, from: "error_reports@thecourseforum.com", subject: 'Error Report from ' + (@user != nil ? @user.email : "Anonymous"))
  end

  def feedback(user_id, description)
    @user = (user_id != nil ? User.find(user_id) : nil)
    @email = "tjd5at@virginia.edu"
    @description = description
    mail(to: @email, from: "feedback@thecourseforum.com", subject: 'Feedback from ' + (@user != nil ? @user.email : "Anonymous"))
  end

  def other(user_id, description)
    @user = User.find(user_id)
    @email = "tjd5at@virginia.edu"
    @description = description
    mail(to: @email, from: "other@thecourseforum.com", subject: 'Other questions from ' + @user.email)
  end
end
