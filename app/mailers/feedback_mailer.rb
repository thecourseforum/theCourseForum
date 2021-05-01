#
# Handles feedback submissions
#
class FeedbackMailer < ApplicationMailer

  def feedback(title, userEmail, description)
    @title = title
    @description = description
    @email = 'support@thecourseforum.com'
    @userEmail = userEmail
    mail(to: @email, from: (@userEmail != "" ? @userEmail : "Anonymous"), subject: 'Feedback: ' + @title)
  end
end
