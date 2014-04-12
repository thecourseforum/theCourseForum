class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json

  before_action :is_correct_user, :only => [:edit, :update, :destroy]

  def index
    @reviews = current_user.reviews.sort_by{|r| [r.semester_id ? -(Semester.find(r.semester_id).number) : 1, r.course.subdepartment.mnemonic, r.course.course_number]}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @review = Review.new
    @subdepartments = Subdepartment.all.order(:name)
    @years = (2009..Time.now.year).to_a
   # @courses = Course.all.sort_by{|e| e[:course_number]}
   # @professors = Professor.all.sort_by{|e| e[:last_name]}

    @course_id = params[:c]
    @prof_id = params[:p]

    if @course_id
      @subdepartment = Subdepartment.find(Course.find(@course_id).subdepartment_id)
      @subdept_id = @subdepartment.id
      @courses = Course.where(:subdepartment_id => @subdept_id)
      @professors = Course.find(@course_id).professors_list
      @mnemonic = @subdepartment.mnemonic
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
    @subdepartments = Subdepartment.all.order(:name)
    @years = (2009..Time.now.year).to_a

    @course_id = @review.course_id
    @prof_id = @review.professor_id
    @semester_season = (@review.semester != nil ? @review.semester.season : nil)
    @semester_year = (@review.semester != nil ? @review.semester.year : nil)

    @subdepartment = Subdepartment.find(Course.find(@course_id).subdepartment_id)
    @subdept_id = @subdepartment.id
    @courses = Course.where(:subdepartment_id => @subdept_id)
    @professors = Course.find(@course_id).professors_list
    @mnemonic = @subdepartment.mnemonic
  

  end

  # POST /reviews
  # POST /reviews.json
  def create
    r = Review.find_by(:student_id => current_user.id, :course_id => params[:course_select], :professor_id => params[:prof_select])
    if r != nil
      flash[:notice] = "You have already written a review for this class."
      redirect_to my_reviews_path
      return
    end

    @subdepartments = Subdepartment.all.order(:name)
    @years = (2009..Time.now.year).to_a
    @review = Review.new(review_params)
    @review.professor_id = params[:prof_select]
    @review.course_id = params[:course_select]

    @semester = Semester.where(:season => params[:semester_season], :year => params[:semester_year]).first

    if @semester == nil
      @semester = Semester.create(:season => params[:semester_season], :year => params[:semester_year], :number => Semester.get_number(params))
    end

    @review.semester_id = @semester.id

    @review.student_id = current_user.id
    
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
    @subdepartments = Subdepartment.all.order(:name)
    @years = (2009..Time.now.year).to_a

    respond_to do |format|
      if @review.update_attributes(review_params)
        
        @semester = Semester.where(:season => params[:semester_season], :year => params[:semester_year]).first
        @review.semester_id = @semester.id
        @review.save

        format.html { redirect_to my_reviews_path, notice: 'Review was successfully updated.' }
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

  def vote_up
    @review = Review.find(params[:review_id])

    current_user.unvote_for(@review)
    
    current_user.vote_for(@review)

    render :nothing => true
  end

  def vote_down
    @review = Review.find(params[:review_id])

    current_user.unvote_for(@review)

    current_user.vote_against(@review)

    render :nothing => true
  end

private
  def review_params
    params.require(:review).permit(:comment, :professor_rating, :enjoyability,
      :difficulty, :amount_reading, :amount_writing, :amount_group, :amount_homework,
      :only_tests, :recommend, :ta_name)
  end

  def is_correct_user
    @review = Review.find(params[:id])
    if current_user.id != @review.student_id
      redirect_to my_reviews_path
    end
  end
  
end
