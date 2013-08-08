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
    @user = User.new(user_params)
    # TODO Check if submitted email is in our list of professor emails
    # If so, create a professor_user, if not, create a student
    # DON'T use the existence of grad_year for this purpose
    # Check the user is valid? before creating the student or professor

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
      if @user.update_attributes(user_params)
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
    params.require(:user).permit(:email, :first_name, :last_name, :old_password, :password, :password_confirmation, :subscribed_to_email)
  end

end
end
