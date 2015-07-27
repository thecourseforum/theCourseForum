class SectionProfessor < ActiveRecord::Base
  belongs_to :section
  belongs_to :professor

  after_create :create_course_professor_stats
  after_destroy :destroy_course_professor_stats

  def create_course_professor_stats
    stat = Stat.find_by(:course_id => section.course.id, :professor_id => professor.id)
    unless stat
      Stat.create(:course_id => section.course.id, :professor_id => professor.id)
    end
  end

  def destroy_course_professor_stats
    if section.course and !section.course.professors.include?(professor)
      Stat.find_by(:course_id => section.course.id, :professor_id => professor.id).destroy
    end
  end
end
