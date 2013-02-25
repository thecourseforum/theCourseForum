class SemestersController < ApplicationController
  # GET /semesters
  # GET /semesters.json
  def index
    @semesters = Semester.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @semesters }
    end
  end

  # GET /semesters/1
  # GET /semesters/1.json
  def show
    @semester = Semester.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @semester }
    end
  end

  # GET /semesters/new
  # GET /semesters/new.json
  def new
    @semester = Semester.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @semester }
    end
  end

  # GET /semesters/1/edit
  def edit
    @semester = Semester.find(params[:id])
  end

  # POST /semesters
  # POST /semesters.json
  def create
    @semester = Semester.new(params[:semester])

    respond_to do |format|
      if @semester.save
        format.html { redirect_to @semester, notice: 'Semester was successfully created.' }
        format.json { render json: @semester, status: :created, location: @semester }
      else
        format.html { render action: "new" }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /semesters/1
  # PUT /semesters/1.json
  def update
    @semester = Semester.find(params[:id])

    respond_to do |format|
      if @semester.update_attributes(params[:semester])
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semesters/1
  # DELETE /semesters/1.json
  def destroy
    @semester = Semester.find(params[:id])
    @semester.destroy

    respond_to do |format|
      format.html { redirect_to semesters_url }
      format.json { head :no_content }
    end
  end
end
