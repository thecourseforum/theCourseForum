class CourseProfessorsController < ApplicationController
  # GET /course_professors
  # GET /course_professors.json
  def index
    @course = Course.find(params[:c])
    @professor = Professor.find(params[:p])
    @professors = @course.professors_list
    @subdepartment = Subdepartment.where(:id => @course.subdepartment_id).first()

    @reviews_temp = Review.where(:course_id => @course.id, :professor_id => @professor.id).all.sort_by{|r| - r.created_at.to_i}
    @reviews = @reviews_temp.paginate(:page => params[:page], :per_page=> 10)
    @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN course_semesters b ON a.id=b.course_id JOIN sections c ON b.id=c.course_semester_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", @course.id, @professor.id])

    #used to pass grades to the donut chart
    gon.grades = @grades

    @rev_ratings = {}
    @rev_emphasizes = {:reading_count => 0, :writing_count => 0, 
      :group_count => 0, :homework_count => 0, :test_count => 0,
      :reading => 0, :writing => 0, :group => 0, :homework => 0}

    if @reviews.length > 0
      @rev_ratings = get_review_ratings
      @rev_emphasizes = get_review_emphasizes
      respond_to do |format|
        format.html # index.html.haml
        format.json { render json: @course_professors }
      end
    else
      respond_to do |format|
        format.html
      end
    end

  end

  # GET /course_professors/1
  # GET /course_professors/1.json
  def show
    @course_professor = CourseProfessor.find(params[:id])

    @reviews_temp = @course_professor.reviews.sort_by{|r| - r.created_at.to_i}
    @reviews = @reviews_temp.paginate(:page => params[:page], :per_page=> 2)

    @grades = @course_professor.grades
    @course = Course.where(:id => @course_professor.course_id).first()
    @subdepartment = Subdepartment.where(:id => @course.subdepartment_id).first()
    @professor = Professor.where(:id => @course_professor.professor_id).first()
    @paginate = @course_professor.reviews.paginate(page: 1, per_page: 2)
    @professors = CourseProfessor.where("course_id = ?", @course[:id])
      .joins(:professor)

    #used to pass grades to the donut chart
    gon.grades = @grades

    if @reviews.length > 0
      @rev_ratings = get_review_ratings
      @rev_emphasizes = get_review_emphasizes
    end

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @course_professor }
    end
  end

  # Get aggregated course ratings
  # @todo this could be cleaner
  def get_review_ratings
    ratings = {
      prof: 0,
      enjoy: 0,
      difficulty: 0,
      recommend: 0
    }

    @reviews.each do |r|
      ratings[:prof] += r.professor_rating
      ratings[:enjoy] += r.enjoyability
      ratings[:difficulty] += r.difficulty
      ratings[:recommend] += r.recommend
    end

    ratings[:overall] = (ratings[:prof] + ratings[:enjoy] + ratings[:recommend]) / 3

    num_reviews = @reviews.length

    ratings.each_with_object({}) { |(k, v), h|
       h[k] = (v / num_reviews).round(2)
    }
  end

  #Get aggregated emphasizes numbers
  #@todo this needs serious cleanup
  def get_review_emphasizes
    emphasizes = {
      reading: 0,
      reading_count: 0,
      writing: 0,
      writing_count: 0,
      group: 0,
      group_count: 0,
      homework: 0,
      homework_count: 0,
      test_count: 0
    }

    @reviews.each do |r|
      if r.amount_reading != nil && r.amount_reading > 0
        emphasizes[:reading] += r.amount_reading
        emphasizes[:reading_count] += 1
      end
      if r.amount_writing != nil && r.amount_writing > 0
        emphasizes[:writing] += r.amount_writing
        emphasizes[:writing_count] += 1
      end
      if r.amount_group != nil && r.amount_group > 0
        emphasizes[:group] += r.amount_group
        emphasizes[:group_count] += 1
      end
      if r.amount_homework != nil && r.amount_homework > 0
        emphasizes[:homework] += r.amount_homework
        emphasizes[:homework_count] += 1
      end
      if r.only_tests
        emphasizes[:test_count] += 1
      end
    end

    if emphasizes[:reading_count] > 0
      emphasizes[:reading] = (emphasizes[:reading] / emphasizes[:reading_count]).round(2)
    end
    if emphasizes[:writing_count] > 0
      emphasizes[:writing] = (emphasizes[:writing] / emphasizes[:writing_count]).round(2)
    end
    if emphasizes[:group_count] > 0
      emphasizes[:group] = (emphasizes[:group] / emphasizes[:group_count]).round(2)
    end
    if emphasizes[:homework_count] > 0
      emphasizes[:homework] = (emphasizes[:homework] / emphasizes[:homework_count]).round(2)
    end

    emphasizes
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
    redirect_to @course_professor
  end

  # POST /course_professors
  # POST /course_professors.json
  def create
    @course_professor = CourseProfessor.new(course_professor_params)

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
    redirect_to @course_professor
    return

    respond_to do |format|
      if @course_professor.update_attributes(course_professor_params)
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

private
  def course_professor_params
    params.require(:course_professor).permit(:course_id, :professor_id)
  end

end
