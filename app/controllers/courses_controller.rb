class CoursesController < ApplicationController
  
  def show
    @course = Course.find(params[:id])
    @subdepartment = Subdepartment.find_by_id(@course.subdepartment_id)

    last_four_years = current_user.settings(:last_four_years).professors

    if last_four_years
      semesters_ids = Semester.where("year > ?", (Time.now.-4.years).year).pluck(:id)
      @professors = Professor.where(id: SectionProfessor.where(section_id: @course.sections.where(semester_id: semesters_ids).pluck(:id)).pluck(:professor_id))
    else
      @professors = @course.professors_list.sort_by{|p| p.last_name.downcase}
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course, :methods => :professors_list}
    end
  end

  private
    def course_params
      params.require(:course).permit(:course_number, :title)
    end
end
