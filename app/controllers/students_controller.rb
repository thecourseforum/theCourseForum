class StudentsController < ApplicationController
  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    @user = User.find_by_student_id(@student.id)
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])
    @user = User.new(email: params[:user][:email], old_password: params[:user][:old_password])
    @user.old_password_confirmation = params[:user][:old_password_confirmation]

    respond_to do |format|
      if (@student.save && @user.save)
        @user.student_id = @student.id
        @user.save
        format.html { redirect_to '/browse', notice: 'Welcome to theCourseForum!' }
        format.json { render json: @student, status: :created, location: @student }
      else
        if @student.save
          @student.destroy
        end
        if @user.save
          @user.destroy
        end
        format.html { redirect_to :root }
        format.json { render json: @student.errors, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end
end
