class SessionsController < Devise::SessionsController

  skip_before_action :check_info, :only => :destroy

  def create
    @user = User.find_by(email: params[:user][:email])
    
    if @user && (@user.old_password != nil)
      if @user.old_authenticate(params[:user][:password])
        @user.migrate(params[:user][:password])
      end
      
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(:user, @user)
      if @user.student
        @user.student.destroy
      end
      redirect_to student_sign_up_path
    elsif @user && @user.valid_password?(params[:user][:password])
      super
    else
      redirect_to new_user_session_path, notice: 'Invalid email or password.', :email => params[:user][:email]
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    binding.pry
    a = stored_location_for(resource_or_scope)
    if a != nil && a.include?('confirmation')
      signed_in_root_path(resource_or_scope)
    else
      a || signed_in_root_path(resource_or_scope)
    end
  end

end
