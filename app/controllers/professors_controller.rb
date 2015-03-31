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
    @courses = @professor.courses_list.sort_by{|c| [c.subdepartment.mnemonic, c.course_number]}
    @total_reviews = 0
    @avg_rating = 0;

    @courses.each do |c|
      @all_reviews = @professor ? Review.where(:course_id => c.id, :professor_id => @professor.id) : Review.where(:course_id => c.id)
      @total_reviews += @all_reviews.count.to_f
    end

    @courses.each do |c|
      @all_reviews = @professor ? Review.where(:course_id => c.id, :professor_id => @professor.id) : Review.where(:course_id => c.id)
      @avg_rating_hash = get_review_ratings
      @avg_rating += @avg_rating_hash / @total_reviews
    end      

    @avg_rating = @avg_rating.round(2)

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
