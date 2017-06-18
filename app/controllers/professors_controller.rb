class ProfessorsController < ApplicationController
  # GET /professors
  # GET /professors.json
  def index
    @professors = Professor.all.sort { |p1, p2| 
      (p1.last_name + p1.first_name) <=> (p2.last_name + p2.first_name) }

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @professors }
    end
  end

  # GET /professors/1
  # GET /professors/1.json
  def show
    @professor = Professor.find(params[:id])

    # Get courses that professors has taught and corresponding last semester that THIS PROFESSOR taught it 
    @courses = @professor.sections.joins(:semester).includes(:course => :subdepartment).select("course_id, max(semesters.number) AS semester_number").group(:course_id).sort_by do |section| 
      [section.course.subdepartment.mnemonic, section.course.course_number]
    end.map do |course_data|
      {
        :course => course_data.course,
        :semester => Semester.find_by(:number => course_data.semester_number)
      }
    end

    # Get all reviews
    @all_reviews = Review.where(:professor_id => @professor.id)
    @reviews_no_comments = @all_reviews.where(:comment => "")
    @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| - r.created_at.to_i}
    # @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 15)
    @total_review_count = @all_reviews.count

    # Chunking! (by subdepartment)
    @course_groups = @courses.chunk{|course| course[:course].subdepartment}

    @avg_rating = @all_reviews.average("(professor_rating + enjoyability + recommend) / 3")
    @avg_difficulty = @all_reviews.average(:difficulty)

    # Format so always two decimal places
    @avg_rating = @avg_rating ? sprintf('%.2f', @avg_rating) : "N/A"
    @avg_difficulty = @avg_difficulty ? sprintf('%.2f', @avg_difficulty) : "N/A"

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: {professor: @professor, course_professors: @course_professors} }
      format.js {render :partial => 'classlist', :locals => {:course_professors => @course_professors}}
    end
  end

  def reviews
    @all_reviews = Review.where(:professor_id => params[:professor_id])
    @reviews_voted_up = current_user ? current_user.votes.where(:vote => 1).pluck(:voteable_id) : []
    @reviews_voted_down = current_user ? current_user.votes.where(:vote => 0).pluck(:voteable_id) : []

    @sort_type = params[:sort_type]
    if @sort_type != nil
      case @sort_type
          when "recent"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.created_at.to_i]}
          when "helpful"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-(r.votes_for-r.votes_against), -r.created_at.to_i]}
          when "highest"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.overall, -r.created_at.to_i]}
          when "lowest"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [r.overall, -r.created_at.to_i]}
          when "controversial"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-r.votes_for/r.overall, -r.created_at.to_i]}
          when "semester"
            @reviews_with_comments = @all_reviews.where.not(:comment => "").where.not(:semester_id => nil).sort_by{|r| [-r.semester_id, r.created_at.to_i]}
          else
            @reviews_with_comments = @all_reviews.where.not(:comment => "")
          end
    end

    render partial: '/courses/reviews', locals: { reviews_with_comments: @reviews_voted_up, reviews: @reviews_voted_up, reviews_voted_down: @reviews_voted_down }, layout: false
    
  end

  private
    def professor_params
      params.require(:professor).permit(:email_alias, :middle_name, :preferred_name)
    end

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
    end
end
