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

  def self.current
    semester_id = Semester.find_by(:year => 2016, :season => 'Spring').id
    Course.where(:last_taught_semester_id => semester_id)
  end

  def professors_list
    self.professors.uniq{ |p| p.id }.sort_by{|p| p.last_name}
  end

  def mnemonic_number
    if subdepartment
      @mnemonic_number ||= "#{subdepartment.mnemonic} #{course_number}"
    else
      "N/A"
    end
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

  def self.find_by_mnemonic_number(mnemonic_number)
    if mnemonic_number.class == Array
      return mnemonic_number.map do |mnemonic|
        self.find_by_mnemonic_number(mnemonic)
      end
    end
    mnemonic, number = *mnemonic_number.split(' ')
    subdepartment = Subdepartment.includes(:courses).find_by(:mnemonic => mnemonic)
    if subdepartment
      subdepartment.courses.find do |course|
        course.course_number == number.to_i
      end
    else
      nil
    end
  end

  def self.update_last_taught_semester
    Course.includes(:sections).load.each do |course|
      number = course.sections.map(&:semester).uniq.compact.map(&:number).sort.last
      if number
        course.update(:last_taught_semester_id => Semester.find_by(:number => number).id)
      else
        puts "No sections with semesters for course ID: #{course.id}"
      end
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
  def get_grade_percentages(professor_id)
    if professor_id != -1
      professor = professors.find do |professor|
        professor.id == professor_id
      end
      @grades = grades.select do |grade|
        grade.section.professors.map(&:id).include?(professor.id)
      end
    else
      @grades = grades
    end

    total = @grades.map(&:total).sum

    percentages = Hash[Grade.mapping.map do |stat|
      percentage = @grades.map do |grade|
        grade.send("count_#{stat}".to_sym)
      end.map(&:to_f).sum.to_f / total
      [stat, percentage]
    end]

    if professor
      percentages[:gpa] = stats.find do |stat|
        stat.professor_id == professor.id
      end.gpa
    else
      percentages[:gpa] = overall_stats.gpa
    end

    percentages[:total] = total
    percentages

  end

  def create_overall_stats
    Stat.create(:course_id => id)
  end

end
