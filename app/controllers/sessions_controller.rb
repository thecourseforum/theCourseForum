class SessionsController < Devise::SessionsController

  def create
    @user = User.find_by_email(params[:email])

    if @user && (@user.old_password != nil)
      @user.migrate(params[:password])
      super
    elsif 
      super
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

end
