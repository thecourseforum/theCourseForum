class CourseProfessorsController < ApplicationController
  # GET /course_professors
  # GET /course_professors.json
  def index
    @course = Course.find(params[:c])
    @professor = Professor.find(params[:p])
    @sort_type = params[:sort]
    @professors = @course.professors_list.sort_by{|p| p.last_name}
    @subdepartment = Subdepartment.where(:id => @course.subdepartment_id).first()

    @naughty_words = "fuck|shit|damn|damm|stupid|bitch|ass|dick|bamf|prick|bastard"

    @all_reviews = Review.where(:course_id => @course.id, :professor_id => @professor.id)
    @reviews_no_comments = @all_reviews.where(:comment => "")
    @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| - r.created_at.to_i}

    if @sort_type != nil
      if @sort_type == "helpful"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for, -r.created_at.to_i]}
      elsif @sort_type == "highest"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.overall, -r.created_at.to_i]}
      elsif @sort_type == "lowest"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [r.overall, -r.created_at.to_i]}
      elsif @sort_type == "controversial"  
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for/r.overall, -r.created_at.to_i]}
      elsif @sort_type == "fun"  
        @reviews_with_comments = @all_reviews.find_by_sql("SELECT reviews.* FROM reviews WHERE reviews.course_id = #{@course.id} AND reviews.professor_id=#{@professor.id} AND comment REGEXP '#{@naughty_words}'").sort_by{|r| -r.created_at.to_i}
      end

    end


    @total_review_count = @reviews_with_comments.count + @reviews_no_comments.count

    @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 10)

    @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN course_semesters b ON a.id=b.course_id JOIN sections c ON b.id=c.course_semester_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", @course.id, @professor.id])
    #used to pass grades to the donut chart
    gon.grades = @grades

    @rev_ratings = {}
    @rev_emphasizes = {:reading_count => 0, :writing_count => 0, 
      :group_count => 0, :homework_count => 0, :test_count => 0,
      :reading => 0, :writing => 0, :group => 0, :homework => 0}

    if @all_reviews.length > 0
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

  # Get aggregated course ratings
  # @todo this could be cleaner
  def get_review_ratings
    ratings = {
      prof: 0,
      enjoy: 0,
      difficulty: 0,
      recommend: 0
    }

    @all_reviews.each do |r|
      ratings[:prof] += r.professor_rating
      ratings[:enjoy] += r.enjoyability
      ratings[:difficulty] += r.difficulty
      ratings[:recommend] += r.recommend
    end

    ratings[:overall] = (ratings[:prof] + ratings[:enjoy] + ratings[:recommend]) / 3

    ratings.each do |k, v|
      ratings[k] = (v / @all_reviews.count.to_f).round(2)
    end
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

    @all_reviews.each do |r|
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
  
  private
    def course_professor_params
      params.require(:course_professor).permit(:course_id, :professor_id)
    end

end
