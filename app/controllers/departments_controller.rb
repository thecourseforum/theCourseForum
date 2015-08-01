class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.json
  def index
    if current_user == nil
      redirect_to root_url
      return
    end
    subdepartments = Subdepartment.all
    departments = Department.all.order(:name)
    departments.uniq {|subdepartments| subdepartments.name}
    schools = School.all.order(:name)
    artSchoolId = 1
    engrSchoolId = 2

    @artDeps = columnize(departments.select{|d| d.school_id == artSchoolId})
    @engrDeps = columnize(departments.select{|d| d.school_id == engrSchoolId })
    @otherSchools = columnize(departments.select{|d| d.school_id != artSchoolId && d.school_id != engrSchoolId })

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments }
    end
  end

  # GET /departments/1
  def show
    @department = Department.includes(:subdepartments => [:courses => [:overall_stats, :last_taught_semester]]).find(params[:id])

    @subdepartments = @department.subdepartments.sort_by(&:mnemonic)

    @groups = @subdepartments.map do |subdepartment|
      subdepartment.courses.sort_by(&:course_number).chunk do |course|
        course.course_number / 1000
      end.map(&:last)
    end

    @current_semester = Semester.find_by(:year => 2015, :season => 'Fall')

    @current_courses = @department.courses.where(:last_taught_semester => @current_semester)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

 
  private
    def department_params
      params.require(:department).permit(:name)
    end

end
