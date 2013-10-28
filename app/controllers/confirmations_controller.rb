class ConfirmationsController < Devise::ConfirmationsController

  def after_confirmation_path_for(resource_name, resource)
    @prof_emails = Professor.pluck(:email_alias).map{|email| (email == nil ? "" : email) + "@virginia.edu"}
    
    if @prof_emails.include? current_user.email
      professor_sign_up_path
    else
      student_sign_up_path
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    sign_in(resource_name, resource)    

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
