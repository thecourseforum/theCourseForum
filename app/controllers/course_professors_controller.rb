class CourseProfessorsController < ApplicationController
  # GET /course_professors
  # GET /course_professors.json
  def index
    @course_professors = CourseProfessor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @course_professors }
    end
  end

  # GET /course_professors/1
  # GET /course_professors/1.json
  def show
    @course_professor = CourseProfessor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course_professor }
    end
  end

  # GET /course_professors/new
  # GET /course_professors/new.json
  def new
    @course_professor = CourseProfessor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course_professor }
    end
  end

  # GET /course_professors/1/edit
  def edit
    @course_professor = CourseProfessor.find(params[:id])
  end

  # POST /course_professors
  # POST /course_professors.json
  def create
    @course_professor = CourseProfessor.new(params[:course_professor])

    respond_to do |format|
      if @course_professor.save
        format.html { redirect_to @course_professor, notice: 'Course professor was successfully created.' }
        format.json { render json: @course_professor, status: :created, location: @course_professor }
      else
        format.html { render action: "new" }
        format.json { render json: @course_professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /course_professors/1
  # PUT /course_professors/1.json
  def update
    @course_professor = CourseProfessor.find(params[:id])

    respond_to do |format|
      if @course_professor.update_attributes(params[:course_professor])
        format.html { redirect_to @course_professor, notice: 'Course professor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course_professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_professors/1
  # DELETE /course_professors/1.json
  def destroy
    @course_professor = CourseProfessor.find(params[:id])
    @course_professor.destroy

    respond_to do |format|
      format.html { redirect_to course_professors_url }
      format.json { head :no_content }
    end
  end
end
