class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, if: -> { amazon_public_site? and ['show', 'reviews'].include?(action_name)}
  
  def show
    if !current_user and !params[:p] and amazon_public_site?
      case params[:id]
      when '1642'
        params[:p] = 702
      when '1646'
        params[:p] = 4474
      when '570'
        params[:p] = 231
      when '1027'
        params[:p] = 4106
      end
    end
    unless params[:p]
      redirect_to :action => "show_professors" and return
    end
    @course = Course.includes(:grades => [:section => :professors]).find(params[:id])
    @subdepartment = @course.subdepartment
    @professors = @course.professors.uniq
    @sort_type = params[:sort]

    if params[:p] and params[:p] != 'all' and @course.professors.uniq.map(&:id).include?(params[:p].to_i)
      @professor = Professor.find(params[:p])

      @section_ids = SectionProfessor.where(:section_id => @course.sections.pluck(:id)).where(:professor_id => params[:p]).flat_map(&:section_id)
      @book_requirements = BookRequirement.where(:section_id => @section_ids)

      @books_count = @book_requirements.count != 0 ? @book_requirements.map(&:book).uniq.count : 0
      @required_books  = @book_requirements.where(:status => "Required").count != 0 ? @book_requirements.where(:status => "Required").map(&:book).uniq : []
      @recommended_books  = @book_requirements.where(:status => "Recommended").count != 0 ? @book_requirements.where(:status => "Recommended").map(&:book).uniq : []
      @optional_books  = @book_requirements.where(:status => "Optional").count != 0 ? @book_requirements.where(:status => "Optional").map(&:book).uniq : []
      @other_books = @course.books.uniq - @required_books - @recommended_books - @optional_books
    else
      @books_count = @course.books.uniq.count
      @required_books  = @course.book_requirements_list("Required")
      @recommended_books  = @course.book_requirements_list("Recommended")
      @optional_books  = @course.book_requirements_list("Optional")
      @other_books = @course.books.uniq - @required_books - @recommended_books - @optional_books      
    end

    @all_reviews = @professor ? Review.where(:course_id => @course.id, :professor_id => @professor.id).includes(:votes) : Review.where(:course_id => @course.id).includes(:votes)
    @reviews_no_comments = @all_reviews.where(:comment => "")
    @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| - r.created_at.to_i}
    # @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 15)
    @total_review_count = @all_reviews.count

    add_breadcrumb 'Departments', departments_url
    add_breadcrumb @subdepartment.name, department_path(@subdepartment.departments.first)
    add_breadcrumb @course.title, "#{course_path(@course)}/professors"
    add_breadcrumb @professor ? @professor.full_name : 'All Professors'

    if @sort_type != nil
      if @sort_type == "helpful"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for, -r.created_at.to_i]}
      elsif @sort_type == "highest"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.overall, -r.created_at.to_i]}
      elsif @sort_type == "lowest"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.overall, -r.created_at.to_i]}
        puts "---------------------------------" + @reviews_with_comments[0].to_s + "-------------------------------"
      elsif @sort_type == "controversial"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for/r.overall, -r.created_at.to_i]}
      elsif @sort_type == "fun"
        @reviews_with_comments = @all_reviews.find_by_sql("SELECT reviews.* FROM reviews WHERE reviews.course_id = #{@course.id} AND reviews.professor_id=#{@professor.id} AND comment REGEXP '#{@naughty_words}'").sort_by{|r| -r.created_at.to_i}
      elsif @sort_type == "semester"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").where.not(:semester_id => nil).sort_by{|r| [r.semester_id, r.created_at.to_i]}
      end
    end

    @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 15)

    @rev_ratings = get_review_ratings
    @rev_emphasizes = get_review_emphasizes
    
    respond_to do |format|
      format.html # show.html.slim
      format.json { render json: @course, :methods => :professors_list}
    end
  end


  def show_professors
    @course = Course.includes(:stats => :professor, :sections => [:professors, :semester]).find(params[:id])
    @subdepartment = @course.subdepartment
    add_breadcrumb 'Departments', departments_url
    add_breadcrumb @subdepartment.name, department_path(@subdepartment.departments.first)
    add_breadcrumb @course.title
    @professors = @course.professors.uniq.sort_by(&:last_name)

    @professors_semester = {}
    @course.sections.each do |section|
      section.professors.each do |professor|
        if section.semester
          if !@professors_semester[professor.id] or section.semester.number > @professors_semester[professor.id].number
            @professors_semester[professor.id] = section.semester
          end
        end
      end
    end
    @professors = @professors.sort_by do |professor|
      semester = @professors_semester[professor.id]
      if semester
        -semester.number
      else
        0
      end
    end
    respond_to do |format|
      format.html # show_professors.html.slim
      format.json do
        render :json => {
          :professors_list => @professors
        }
      end
    end
  end

  def reviews
    if params[:professor_id] and params[:professor_id] != "all"
      all_reviews = Review.where(:course_id => params[:course_id], :professor_id => params[:professor_id])
    else
      all_reviews = Review.where(:course_id => params[:course_id])
    end

    @reviews_voted_up = current_user ? current_user.votes.where(:vote => 1).pluck(:voteable_id) : []
    @reviews_voted_down = current_user ? current_user.votes.where(:vote => 0).pluck(:voteable_id) : []

    @sort_type = params[:sort_type]
    if @sort_type != nil
      case @sort_type
          when "recent"
            @reviews_with_comments = all_reviews.where.not(:comment => "").sort_by{|r| [-r.created_at.to_i]}
          when "helpful"
            @reviews_with_comments = all_reviews.where.not(:comment => "").sort_by{|r| [-(r.votes_for-r.votes_against), -r.created_at.to_i]}
          when "highest"
            @reviews_with_comments = all_reviews.where.not(:comment => "").sort_by{|r| [-r.overall, -r.created_at.to_i]}
          when "lowest"
            @reviews_with_comments = all_reviews.where.not(:comment => "").sort_by{|r| [r.overall, -r.created_at.to_i]}
          when "controversial"
            @reviews_with_comments = all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for/r.overall, -r.created_at.to_i]}
          when "semester"
            @reviews_with_comments = all_reviews.where.not(:comment => "").where.not(:semester_id => nil).sort_by{|r| [-r.semester_id, r.created_at.to_i]}
          else
            @reviews_with_comments = all_reviews.where.not(:comment => "")
          end
    end

    render partial: 'reviews', locals: { reviews_with_comments: @reviews_voted_up, reviews: @reviews_voted_up, reviews_voted_down: @reviews_voted_down }, layout: false
    
  end

  private

  def amazon_public_site?
    course = params[:id] || params[:course_id]
    [1642, 1646, 570, 1027].include?(course.to_i)
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
        if @all_reviews.count.to_f > 0
          ratings[k] = (v / @all_reviews.count.to_f).round(2)
        else
          ratings[k] = "--"
        end
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
