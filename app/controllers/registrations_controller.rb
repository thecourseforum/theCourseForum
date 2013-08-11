class RegistrationsController < Devise::RegistrationsController

  def new
    @user = User.new
    super
  end

  def create
    @user = User.new(user_params)
    binding.pry
    if @user.save
      if @user.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(:user, @user)
        respond_with @user, :location => after_sign_up_path_for(@user)
      else
        set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with @user, :location => after_inactive_sign_up_path_for(@user)
      end
    else
      clean_up_passwords @user
      redirect_to root_path
    end
  end

  def after_sign_up_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      browse_path
    else
      super
    end
  end

  private 

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, 
        :first_name, :last_name)
  end

end
