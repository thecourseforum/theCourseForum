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
    @reviews = @course_professor.reviews.sort_by{|r| - r.created_at.to_i}
    @grades = @course_professor.grades
    @course = Course.where(:id => @course_professor.course_id).first()
    @subdepartment = Subdepartment.where(:id => @course.subdepartment_id).first()
    @professor = Professor.where(:id => @course_professor.professor_id).first()

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
      if r.amount_reading > 0
        emphasizes[:reading] += r.amount_reading
        emphasizes[:reading_count] += 1
      end
      if r.amount_writing > 0
        emphasizes[:writing] += r.amount_writing
        emphasizes[:writing_count] += 1
      end
      if r.amount_group > 0
        emphasizes[:group] += r.amount_group
        emphasizes[:group_count] += 1
      end
      if r.amount_homework > 0
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
    redirect_to @course_professor
    return

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
