class SchedulerController < ApplicationController

	def ui
	end

	def search
    unless params[:mnemonic] and params[:course_number]
      render :nothing => true, :status => 404 and return
    else
      subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
      course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept
      
      render :nothing => true, :status => 404 and return unless course

      #Need a better way to get current semester
      #Maybe let user choose?
      current_sections = course.sections.where(semester_id: Semester.find_by(season: "Fall", year: 2014).id)
      
      render json: rsections_to_jssections(current_sections) and return
    end
  end

  def get_course
    unless params[:mnemonic] and params[:course_number]
      render :nothing => true, :status => 404 and return
    else
      subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
      course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept
      
      render :nothing => true, :status => 404 and return unless course
      #pr course
      #course_sections = course.sections.where()
      render json: course and return
      
    end
  end

  def sections
    render :json => {:success => true, :sections => rsections_to_jssections(current_user.sections)}
  end

  def save_course
    subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
    course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept
    
    if !current_user.courses.include? course
      current_user.courses << course
    end

    render :nothing => true
  end

  def save_sections
    sections = Section.find(JSON.parse(params[:sections]))
    current_user.sections = sections
    sections.each do |section|
      unless current_user.courses.include?(section.course)
        current_user.courses << section.course
      end
    end

    render :nothing => true
  end

  def clear_courses
    current_user.courses = []

    render :nothing => true
  end

  # def gen_schedules 
  #   possible_schedules = []
  #   schedule = []
  #   #max_sections = 3
  #   #i=0
  #   #until i > 3
  #   current_user.courses.each do |course|
  #     course.sections.each do |section|
  #       if()
  # end

  private

  def rsections_to_jssections(sections)
    sections.map do |section|
      days = []
      start_times = []
      end_times = []
      # pr section.day_times.to_a
      section.day_times.sort_by{|s| [s.start_time, s.end_time, day_to_number(s.day)] }.each do |day_time|
        days << day_time.day
        start_times << day_time.start_time
        end_times << day_time.end_time
      end
      {
        :section_id => section.id,
        :title => "#{section.course.subdepartment.mnemonic} #{section.course.course_number}",
        :location => section.locations.first.location,
        :days => days,
        :start_times => start_times,
        :end_times => end_times,
        :events => [],
        :allDay => false,
        :professor => section.professors.first.full_name,
        :sis_id => section.sis_class_number
      }
    end
  end

  def day_to_number(day)
    days = ['Mo', 'Tu', 'We', 'Th', 'Fr']
    return days.index(day) == nil ? -1 : days.index(day)
  end

end