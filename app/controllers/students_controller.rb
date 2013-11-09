class StudentsController < ApplicationController

  # POST /students
  # POST /students.json
  def create
    @user = current_user
    @student = Student.new(student_params)
    @majors_list = Major.all.order(:name).map{|m| [m.name, m.id]}

    respond_to do |format|
      if @student.save

        params[:majors].each do |major_num|
          if major_num[1] == ""
            next
          end
          major_id = major_num[1]
          @major = Major.find(major_id)
          @student.majors.push(@major)
        end

        @user.student = @student

        format.html { redirect_to browse_path, notice: 'Welcome to theCourseForum!' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { redirect_to student_sign_up_path }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  

  private
    def student_params
      params.require(:student).permit(:grad_year)
    end

end
