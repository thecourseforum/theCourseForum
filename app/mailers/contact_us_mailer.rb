#require 'slim'
#require 'slim/template/plugin'

class ContactUsMailer < ActionMailer::Base
  default from: "support@thecourseforum.com"

  def error_report(user_id, url, description)
    @user = (user_id != nil ? User.find(user_id) : nil)
    @email = "support@thecourseforum.com"
    @url = url
    @description = description
    mail(to: @email, from: "error_reports@thecourseforum.com", subject: 'Error Report from ' + (@user != nil ? @user.email : "Anonymous"))
  end

  # def feedback(user_id, description)
  #   @user = (user_id != nil ? User.find(user_id) : nil)
  #   @email = "support@thecourseforum.com"
  #   @description = description
  #   mail(to: @email, from: "feedback@thecourseforum.com", subject: 'Feedback from ' + (@user != nil ? @user.email : "Anonymous"))
  # end

  def feedback(arguments = {})
    @description = arguments[:description]
    @description += "\n http://thecourseforum.com/bugs/#{arguments[:id]}"
    mail(to: 'support@thecourseforum.com', from: 'general@thecourseforum.com', subject: 'General Feedback')
  end

  def feedback2(email_from, description)
    @email = "support@thecourseforum.com"
    @email_from = email_from
    @description = description
    mail(to: @email, from: "feedback@thecourseforum.com", subject: 'Feedback from ' + (@email_from != "" ? @email_from : "Anonymous"))
  end

  def other(user_id, description)
    @user = User.find(user_id)
    @email = "support@thecourseforum.com"
    @description = description
    mail(to: @email, from: "other@thecourseforum.com", subject: 'Other questions from ' + @user.email)
  end
end
