class CoursesController < ApplicationController
  
  def show
    @course = Course.find(params[:id])
    @subdepartment = @course.subdepartment
    @professors = @course.professors.uniq
    @sort_type = params[:sort]

    @books_count = @course.books.uniq.count
    @required_books  = @course.book_requirements_list("Required")
    @recommended_books  = @course.book_requirements_list("Recommended")
    @optional_books  = @course.book_requirements_list("Optional")
    @other_books = @course.books.uniq - @required_books - @recommended_books - @optional_books

    if params[:p] and params[:p] != 'all' and @course.professors.uniq.map(&:id).include?(params[:p].to_i)
      @professor = Professor.find(params[:p])
    end

    @all_reviews = @professor ? Review.where(:course_id => @course.id, :professor_id => @professor.id).includes(:votes) : Review.where(:course_id => @course.id).includes(:votes)
    @reviews_no_comments = @all_reviews.where(:comment => "")
    @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| - r.created_at.to_i}
    @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 10)
    @total_review_count = @all_reviews.count

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


    if @professor
      @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", @course.id, @professor.id])
    else
      @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id WHERE a.id=?", @course.id])
    end
    
    @semesters = Semester.where(id: @grades.map{|g| g.section.semester_id}).sort_by{|s| s.number}

    #used to pass grades to the donut chart
    gon.grades = @grades
    gon.semester = 0
    gon.percentages = get_grade_percentages

    @colors = ['#223165', '#15214B', '#0F1932', '#EE5F35', '#D75626', '#C14927','#5A6D8E','#9F9F9F']
    @letters = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+/C/C-', 'Other']

    @semesters = Semester.where(id: @grades.map{|g| g.section.semester_id}).sort_by{|s| s.number}

    @rev_ratings = get_review_ratings
    @rev_emphasizes = get_review_emphasizes
    
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

    # Returns the percentage of A's, B's, C's etc and GPA for the course (1 section or multiple sections)
    def get_grade_percentages
      # these keys will correspond to the the grade's attributes (count_a, count_aminus, etc)
      percentages = {
        a: 0,
        aminus: 0,
        aplus: 0,
        b: 0,
        bminus: 0,
        bplus: 0,
        cplus: 0,
        c: 0,
        cminus: 0,
        cplus: 0,
        d: 0,
        dminus: 0,
        dplus: 0,
        drop: 0,
        f: 0,
        other: 0,
        wd: 0,
        date: 0,
        gpa: 0,
        total: 0
      }

      # Gets the grades for the course or for the professor's sections
      if @professor
        @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", @course.id, @professor.id])
      else
        @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id WHERE a.id=?", @course.id])
      end

      # keep track of the total number of students (for calculating the percentage)
      running_total = 0

      # For each grade returned (section with the number of a's, b's, etc)
      @grades.each do |grade|
          # map those attributes to an array
          grade_count_array = []
          grade.attributes.sort.each do |attr_name, attr_value|
            grade_count_array << attr_value
          end

          # For each key value in the percentages hash
          # its index corresponds to the index of the grade_count_array
          percentages.each_with_index do |(key,value),index| 

            if (index != 16 && index != 17) #don't average the date time, and calculate average gpa differently so skip that
              # if that value is nil, (the first iteration) then simply divide the count by the total number of grades to get the percentage
              if (percentages[key] == nil)
                percentages[key] = grade_count_array[index] / grade.total                      
              # otherwise, multiply the percentage by the previous total, add the count, and divide by the new total to get the new percentage
              else 
                percentages[key] = ((percentages[key] * running_total) + grade_count_array[index].to_f) / (running_total + grade.total).to_f
              end
            # average the gpa by just summing it now, and dividing later (has nothing to do with number of students)
            elsif (index == 17)
              percentages[key]+= grade_count_array[index].to_f
            end
          end
          #increment of the total number of students
          running_total += grade.total
        end
        #average the gpa
        percentages[:gpa] = (percentages[:gpa].to_f)/(@grades.length().to_f)
        #store the total number of students
        percentages[:total] = running_total
        #return
        percentages
    end
    

end

# last_four_years = current_user.settings(:last_four_years).professors

    # if last_four_years
    #   semesters_ids = Semester.where("year > ?", (Time.now.-4.years).year).pluck(:id)
    #   @professors = Professor.where(id: SectionProfessor.where(section_id: @course.sections.where(semester_id: semesters_ids).pluck(:id)).pluck(:professor_id))
    # else