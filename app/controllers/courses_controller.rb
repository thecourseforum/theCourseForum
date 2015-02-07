class CoursesController < ApplicationController
  
  def show
    @course = Course.find(params[:id])
    @subdepartment = Subdepartment.find(@course.subdepartment_id)
    @professors = @course.professors_list.sort_by{|p| p.last_name.downcase}

    if params[:p] and @professors.map(&:id).include?(params[:p])
      @selected_professor_id = params[:p]
    end

    @all_reviews = Review.where(:course_id => @course.id)
    @reviews_no_comments = @all_reviews.where(:comment => "")
    @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| - r.created_at.to_i}
    @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 10)
    @total_review_count = @all_reviews.count


    @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id WHERE a.id=?", @course.id])
    
    #used to pass grades to the donut chart
    gon.grades = @grades
    gon.semester = 0

    @colors = ['#5254a3', '#6b6ecf', '#9c9ede', '#31a354', '#74c476', '#a1d99b','#fdae6b', '#969696']
    @letters = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+/C/C-', 'O*']

    @semesters = Semester.where(id: @grades.map{|g| g.semester_id}).sort_by{|s| s.number}

    if @all_reviews.length > 0
      @rev_ratings = get_review_ratings
      @rev_emphasizes = get_review_emphasizes
    end

    respond_to do |format|
      format.html # show.html.slim
      format.json { render json: @course, :methods => :professors_list}
    end
  end

  private
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

end

# last_four_years = current_user.settings(:last_four_years).professors

    # if last_four_years
    #   semesters_ids = Semester.where("year > ?", (Time.now.-4.years).year).pluck(:id)
    #   @professors = Professor.where(id: SectionProfessor.where(section_id: @course.sections.where(semester_id: semesters_ids).pluck(:id)).pluck(:professor_id))
    # else