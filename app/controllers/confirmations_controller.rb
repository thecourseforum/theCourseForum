class ConfirmationsController < Devise::ConfirmationsController

  def after_confirmation_path_for(resource_name, resource)
    @prof_emails = Professor.pluck(:email_alias).map{|email| email + "@virginia.edu"}
    
    if @prof_emails.include? current_user.email
      professor_sign_up_path
    else
      student_sign_up_path
    end
  end

end