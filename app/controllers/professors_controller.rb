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
    @reviews = Review.where(:professor_id => @professor.id)

    # Chunking! (by subdepartment)
    @course_groups = @courses.chunk{|course| course[:course].subdepartment}

    @total_reviews = @reviews.count
    @avg_rating = @reviews.average("(professor_rating + enjoyability + recommend) / 3")
    @avg_difficulty = @reviews.average(:difficulty)

    # Format so always two decimal places
    @avg_rating = @avg_rating ? sprintf('%.2f', @avg_rating) : "N/A"
    @avg_difficulty = @avg_difficulty ? sprintf('%.2f', @avg_difficulty) : "N/A"

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: {professor: @professor, course_professors: @course_professors} }
      format.js {render :partial => 'classlist', :locals => {:course_professors => @course_professors}}
    end
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
