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

  def sections
    render :json => {:success => true, :sections => rsections_to_jssections(current_user.sections)}
  end

  def save_course
    subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
    course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept

    current_user.courses << course unless current_user.courses.include? course

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

  def schedules
    # Generate an array of arrays, where each course is mapped to an array of its sections
    # If there are no sections for that course for the desired semester, then remove that course by nil then remove through Array.compact
    course_sections = current_user.courses.map do |course|
      sections = course.sections.where(:semester_id => 28)
      sections.empty? ? nil : sections
    end.compact

    # Permute through the array of arrays to generate all possible combinations of schedules
    schedules = course_sections.inject(&:product).map(&:flatten)

    # Examine each schedule and only keep the ones that do not conflict
    # If a schedule has conflicts - is turned into nil and removed in Array.compact
    valid_schedules = schedules.map do |sections|
      schedule = []
      sections.each do |section|
        if conflicts(schedule, section)
          break
        else
          schedule << section
        end
      end
      sections.count == schedule.count ? rsections_to_jssections(schedule) : nil
    end.compact

    render :json => valid_schedules and return
  end

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

  def conflicts(partial_schedule, new_section)
    if params[:mornings] == 'true'
      new_section.day_times.each do |day_time|
        if day_time.start_time.sub(':', '.').to_f < 10
          return true
        end
      end
    end
    if params[:evenings] == 'true'
      new_section.day_times.each do |day_time|
        if day_time.end_time.sub(':', '.').to_f > 17
          return true
        end
      end
    end
    if params[:fridays] == 'true'
      new_section.day_times.each do |day_time|
        if day_time.day = 'Fr'
          return true
        end
      end
    end
    partial_schedule.each do |section|
      if section.conflicts?(new_section)
        return true
      end
    end
    return false
  end

  def day_to_number(day)
    days = ['Mo', 'Tu', 'We', 'Th', 'Fr']
    return days.index(day) == nil ? -1 : days.index(day)
  end

end