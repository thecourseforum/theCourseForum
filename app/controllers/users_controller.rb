class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    redirect_to "users/" + current_user.id.to_s
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if @user.student_id != nil
      @student = Student.find(@user.student_id)
    end
    if @user.professor_id != nil
      @professor = Professor.find(@user.professor_id)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(email: params[:user][:email], old_password: params[:user][:old_password])
    @user.old_password_confirmation = params[:user][:old_password_confirmation]
    if(params[:professor_id] != nil)
      @user.professor_id = params[:professor_id]
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if params[:id] != current_user.id
      return
    end
    if params[:conf] != "true"
      
      @user = User.find(params[:id])
      @user.destroy
      
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :last_login, :old_password, :password, :password_confirmation, :subscribed_to_email)
  end

end
end
