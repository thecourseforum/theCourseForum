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
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    @subdepartments = @department.subdepartments #Subdepartment.where(:department_id => @department.id)

    @subdepartment_ids = @subdepartments.pluck(:id)
    @courses = Course.where(subdepartment_id: @subdepartment_ids)
    @course_ids = @courses.pluck(:id)
    @sections = Section.where(course_id: @course_ids)
    @courses_with_sections_ids = @sections.pluck(:course_id)
    @courses_with_sections = @courses.where(id: @courses_with_sections_ids)
    @subdepartments_with_sections_ids = @courses_with_sections.pluck(:subdepartment_id)
    @subdepartments_with_sections = @subdepartments.where(id: @subdepartments_with_sections_ids)

    @section_ids = @sections.pluck(:id)
    @professor_ids = SectionProfessor.where(section_id: @section_ids).pluck(:professor_id)
    @professors = columnize(Professor.where(id: @professor_ids).uniq.sort_by{|p| p.last_name}, 3)

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
