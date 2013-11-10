class CoursesController < ApplicationController
  
  def show
    @course = Course.find(params[:id])
    @subdepartment = Subdepartment.find_by_id(@course.subdepartment_id)
    @courseprofessors = CourseProfessor.all
    @professors = @course.professors_list.sort_by{|p| p.last_name.downcase}

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
