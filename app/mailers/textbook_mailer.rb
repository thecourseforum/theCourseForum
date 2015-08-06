class TextbookMailer < ActionMailer::Base
  default from: "textbooks@thecourseforum.com"

  def notify_of_post(arguments = {})

    mail(to: '', from: '', subject: '')
  end

  def notify_of_claim(arguments = {})
    
    mail(to: '', from: '', subject: '')
  end

end
