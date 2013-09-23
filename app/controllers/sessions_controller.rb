class SessionsController < Devise::SessionsController

  def create
    @user = User.find_by(email: params[:user][:email])
    
    if @user && (@user.old_password != nil)
      if @user.old_authenticate(params[:user][:password])
        @user.migrate(params[:user][:password])
      end
      super
    else
      flash.now.alert = "Invalid email or password"
      super
    end
  end

end
