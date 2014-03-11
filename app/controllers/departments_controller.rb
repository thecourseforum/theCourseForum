class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.json
  def index
    if current_user == nil
      redirect_to root_url
      return
    end
    subdepartments = Subdepartment.find(:all)
    departments = Department.find(:all, :order => "name")
    departments.uniq {|subdepartments| subdepartments.name}
    schools = School.find(:all, :order => "name")
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
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    @subdepartments = @department.subdepartments #Subdepartment.where(:department_id => @department.id)

    @count = @subdepartments.size

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  private
    def department_params
      params.require(:department).permit(:name)
    end

end
