class ProfessorsController < ApplicationController
  # GET /professors
  # GET /professors.json
  def index
    @professors = Professor.all.sort { |p1, p2| 
      (p1.last_name + p1.first_name) <=> (p2.last_name + p2.first_name) }

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @professors }
    end
  end

  # GET /professors/1
  # GET /professors/1.json
  def show
    @professor = Professor.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: {professor: @professor, course_professors: @course_professors} }
      format.js {render :partial => 'classlist', :locals => {:course_professors => @course_professors}}
    end
  end

  private
    def professor_params
      params.require(:professor).permit(:email_alias, :middle_name, :preferred_name)
    end

end
