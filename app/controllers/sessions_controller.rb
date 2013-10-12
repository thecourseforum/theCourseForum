class SessionsController < Devise::SessionsController

  def create
    @user = User.find_by(email: params[:user][:email])
    
    if @user && (@user.old_password != nil)
      if @user.old_authenticate(params[:user][:password])
        @user.migrate(params[:user][:password])
      end
      super
    elsif @user && @user.valid_password?(params[:user][:password])
      super
    else
      redirect_to new_user_session_path, notice: 'Invalid email or password.' 
    end
  end

end
