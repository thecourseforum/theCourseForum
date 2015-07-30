class Course < ActiveRecord::Base
  belongs_to :subdepartment
  belongs_to :last_taught_semester, :class_name => Semester

  has_many :sections
  has_many :reviews
  has_one :overall_stats, -> { where professor_id: nil }, :dependent => :destroy, :class_name => Stat

  has_many :stats, :dependent => :destroy

  has_many :books, -> { uniq }, :through => :sections
  has_many :book_requirements, :through => :sections

  has_and_belongs_to_many :users

  has_many :section_professors, :through => :sections
  has_many :semesters, :through => :sections
  has_many :professors, :through => :sections
  has_many :departments, through: :subdepartment
  has_many :grades, :through => :sections

  validates_presence_of :title, :course_number, :subdepartment

  after_create :create_overall_stats

  def professors_list
    self.professors.uniq{ |p| p.id }.sort_by{|p| p.last_name}
  end

  def mnemonic_number
    @mnemonic_number ||= "#{subdepartment.mnemonic} #{course_number}"
  end

  def book_requirements_list(status)
    self.book_requirements.where(:status => status).map{|r| r.book}.uniq
  end

  def units
    self.sections.select(:units).max.units.to_i
  end

  def self.offered(id)
    sections = Section.where(:semester_id => id)
    return Hash[sections.map{|section| [section.course_id, true]}]
  end

  def self.find_by_mnemonic_number(mnemonic, number)
    subdepartment = Subdepartment.includes(:courses).find_by(:mnemonic => mnemonic)
    if subdepartment
      subdepartment.courses.find_by(:course_number => number)
    else
      nil
    end
  end

  def self.update_last_taught_semester
    ActiveRecord::Base.connection.execute("SELECT courses.id, max(sections.semester_id) from courses join sections ON courses.id=sections.course_id group by courses.id;").each do |pair|
      Course.find(pair.first).update(:last_taught_semester_id => pair.second)
    end
  end

  # def get_top_review(prof_id = -1)
  #   if prof_id != -1
  #     review = Review.where(:course_id => self.id, :professor_id => prof_id).where.not(:comment => '').last
  #   else 
  #     review = Review.where(:course_id => self.id).where.not(:comment => '').last
  #   end
  #   review ? review.comment : nil
  #   # review.comment
  # end

  def get_review_ratings(prof_id = -1)    
      @all_reviews = prof_id != -1 ? Review.where(:course_id => self.id, :professor_id => prof_id) : Review.where(:course_id => self.id)

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


  # Returns the percentage of A's, B's, C's etc and GPA for the course (1 section or multiple sections)
  def get_grade_percentages(prof_id = -1)
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
    if prof_id != -1      
      @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id JOIN section_professors e ON c.id=e.section_id JOIN professors f ON e.professor_id=f.id WHERE a.id=? AND f.id=?", self.id, prof_id])
    else      
      @grades = Grade.find_by_sql(["SELECT d.* FROM courses a JOIN sections c ON a.id=c.course_id JOIN grades d ON c.id=d.section_id WHERE a.id=?", self.id])
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

  def create_overall_stats
    Stat.create(:course_id => id)
  end

end
