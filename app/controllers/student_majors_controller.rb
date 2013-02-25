class StudentMajorsController < ApplicationController
  # GET /student_majors
  # GET /student_majors.json
  def index
    @student_majors = StudentMajor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_majors }
    end
  end

  # GET /student_majors/1
  # GET /student_majors/1.json
  def show
    @student_major = StudentMajor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_major }
    end
  end

  # GET /student_majors/new
  # GET /student_majors/new.json
  def new
    @student_major = StudentMajor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_major }
    end
  end

  # GET /student_majors/1/edit
  def edit
    @student_major = StudentMajor.find(params[:id])
  end

  # POST /student_majors
  # POST /student_majors.json
  def create
    @student_major = StudentMajor.new(params[:student_major])

    respond_to do |format|
      if @student_major.save
        format.html { redirect_to @student_major, notice: 'Student major was successfully created.' }
        format.json { render json: @student_major, status: :created, location: @student_major }
      else
        format.html { render action: "new" }
        format.json { render json: @student_major.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_majors/1
  # PUT /student_majors/1.json
  def update
    @student_major = StudentMajor.find(params[:id])

    respond_to do |format|
      if @student_major.update_attributes(params[:student_major])
        format.html { redirect_to @student_major, notice: 'Student major was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_major.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_majors/1
  # DELETE /student_majors/1.json
  def destroy
    @student_major = StudentMajor.find(params[:id])
    @student_major.destroy

    respond_to do |format|
      format.html { redirect_to student_majors_url }
      format.json { head :no_content }
    end
  end
end
