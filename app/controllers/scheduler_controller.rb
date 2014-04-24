class SchedulerController < ApplicationController

	def ui
	end

	def search
    unless params[:course]
      render :nothing => true
    else
      mnemonic, course_number = params[:course].split(" ")

      if mnemonic == nil or course_number == nil
        render :nothing => true
        return
      end

      subdept_id = Subdepartment.find_by(mnemonic: mnemonic).id

      if subdept_id == nil
        render :nothing => true
        return
      end

      course = Course.find_by(subdepartment_id: subdept_id, course_number: course_number)

      if course == nil
        render :nothing => true
        return
      end

      sections = course.sections.map do |section|
        days = []
        start_times = []
        end_times = []

        section.day_times.each do |s|
          days.push(s.day)
          start_times.push(s.start_time)
          end_times.push(s.end_time)
        end

        {
          :section_id => section.sis_class_number,
          :title => "#{mnemonic.upcase} #{course_number}",
          :location => section.locations.first.location,
          :days => days,
          :start_times => start_times,
          :end_times => end_times,
          :events => [],
          :allDay => false,
          :professor => section.professors.first.full_name
        }
      end

      render json: sections
    end
  end

  def save
    section = Sections.find(params[:section_id])

    current_user.sections.push(section)

    render :nothing => true
  end

  def delete
    section = Section.find(params[:section_id])
    current_user.sections.remove(section)

    render :nothing => true
  end

  def coursenos
    c = Course.where.not(:title => "")

    values = []

    c.each do |course|
      values.push(course.mnemonic_number)
    end

    respond_to do |format|
      format.json {render json: values}
    end
  end
end