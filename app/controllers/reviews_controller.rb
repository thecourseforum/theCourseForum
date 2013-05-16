class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])
    @course_professor = CourseProfessor.find(@review.course_professor_id)
    @course = Course.find(@course_professor.course_id)
    @subdepartment = Subdepartment.find(@course.subdepartment_id)
    @professor = Professor.find(@course_professor.professor_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @review = Review.new
    @subdepartments = Subdepartment.all.sort_by{|e| e[:name]}
   # @courses = Course.all.sort_by{|e| e[:course_number]}
   # @professors = Professor.all.sort_by{|e| e[:last_name]}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.json
  def create
    
    @review = Review.new(params[:review])
    @review.professor_id = params[:Professor_Select]
    @review.course_id = params[:Course_Select]

    @semester = Semester.where(:season => params[:semester_season], :year => params[:semester_year]).first
    @review.semester_id = @semester.id
    
    respond_to do |format|
      if @review.save
        format.html { redirect_to '/course_professors?c='+@review.course_id.to_s+'&p='+@review.professor_id.to_s, notice: 'Review was successfully created.' }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end
end
