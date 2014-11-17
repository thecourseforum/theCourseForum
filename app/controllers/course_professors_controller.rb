class CourseProfessorsController < ApplicationController
  # GET /course_professors
  # GET /course_professors.json
  def index
    @course = Course.find(params[:c])
    @professor = Professor.find(params[:p])
    @semester = 0
    @sort_type = params[:sort]
    @professors = @course.professors_list.sort_by{|p| p.last_name}
    @subdepartment = Subdepartment.where(:id => @course.subdepartment_id).first()

    @naughty_words = "evil|crazy|regret|tenure|hell|douche|pompous|smug|fuck|shit|damn|damm|stupid|bitch|\Aass|\Adick|bamf|\Aprick|bastard"

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
      elsif @sort_type == "semester"
        @reviews_with_comments = @all_reviews.where.not(:comment => "").sort_by{|r| [-Semester.get_number(:semester_year => r.semester.year, :semester_season => r.semester.season), r.created_at.to_i]}
      end

    end

    @word_cloud_on = current_user.settings(:word_cloud).on

    if @word_cloud_on
      @word_array = get_word_array
    end

    @total_review_count = @reviews_with_comments.count + @reviews_no_comments.count

    @reviews = @reviews_with_comments.paginate(:page => params[:page], :per_page=> 10)

    @colors = ['#5254a3', '#6b6ecf', '#9c9ede', '#31a354', '#74c476', '#a1d99b','#fdae6b', '#969696']
    @letters = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+/C/C-', 'O*']

    # section_professors = SectionProfessor.where(professor_id: @professor.id)
    # sections = Section.where(id: section_professors.pluck(:section_id), course_id: @course.id)
    # @grades = Grade.where(section_id: sections.pluck(:id))

    @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", @course.id, @professor.id])

    @semesters = Semester.where(id: @grades.map{|g| g.semester_id}).sort_by{|s| s.number}

    #used to pass grades to the donut chart
    gon.grades = @grades
    gon.semester = @semester

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
    include ApplicationHelper

    def course_professor_params
      params.require(:course_professor).permit(:course_id, :professor_id)
    end

    def get_word_array()

      all_words = get_words()

      total_count = 0

      all_words.each do |k,v|
        total_count += v
      end

      filter_words = ['the', 'and', 'is', 'was', 'be',
                      'you', 'are', 'to', 'a', 'i', 'in',
                      'but', 'of', 'class', 'this', 'very',
                      'so', 'as', 'if', 'it', 'for',
                      'he', 'she', 'not', 'an', 'can', 'good',
                      'him', 'her', 'that', 'if', 'on', 'with',
                      'had', 'will', 'do', 'professor', 'it\'s', 'his',
                      'go', 'up', 'look', 'all', 'get', 'really', 'pretty',
                      'very', 'lot', 'way', 'take', 'definitely',
                      'about', 'have', 'more', 'one', 'there', '-',
                      'than', 'then', 'thing', 'things', 'often', 'them', '.',
                      'were', 'however', 'course', 'problem',
                      'set', 'sets', 'student', 'students',
                      @professor.last_name.downcase,
                      @professor.first_name.downcase,
                      @subdepartment.mnemonic.downcase]


      words = {}
      @reviews_with_comments.each do |r|
        r.comment.split(" ").each do |word|
          if word.split("").last == "." || word.split("").last == ","
            word = word[0..word.length-2]
          end
          word.downcase!
          if words[word] != nil
            words[word] += 1
          else
            words[word] = 1
          end
        end
      end

      count = 0
      words.each do |k,v|
        count += v
      end

      arr = []
      arr2 = {}

      words.each do |k,v|
        if all_words[k] != nil && (words[k]  / count.to_f > (all_words[k] / total_count.to_f)*1.7)
          if !filter_words.include?(k)
            if arr.length >= 25
              arr.each do |a|
                if a[:weight] < v
                  arr.delete(a)
                  arr.push({text: k, weight: v})
                  arr2.delete(k)
                  arr2[k] = v
                  break
                end
              end
            else
              arr2[k] = v
              arr.push({text: k, weight: v})
            end
          end
        end
      end

      if current_user.settings(:word_cloud).doge && arr2.size >= 3
        a = arr2.sort_by{|k,v| v}.last(3).shuffle

        arr3 = []

        arr3.push({text: "such " + a[0][0], weight: 1})
        arr3.push({text: "many " + a[1][0], weight: 1})
        arr3.push({text: "wow", weight: 1})
        arr3.push({text: "so " + a[2][0], weight: 1})

        arr3
      else
        arr
      end
    end
end
