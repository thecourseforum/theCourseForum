class SchedulerController < ApplicationController

	def ui
	end

	def search
    unless params[:course]
      render :nothing => true
    else
      mnemonic, course_number = params[:course].split(" ")

      subdept_id = Subdepartment.find_by(mnemonic: mnemonic).id

      course = Course.find_by(subdepartment_id: subdept_id, course_number: course_number)

      sections = course.sections

      render json: course.sections.map do |section|
        course = {}

        course[:section_id] = section.sis_class_number
        course[:title] = "#{mnemonic} #{course_number}"
        course[:professor] = "TODO: CHANGE"
        course[:section_type] = section.section_type
        course[:location] = section.locations
        days = []
        start_times = []
        end_times = []

        section.day_times.each do |dt|
          days.push(dt.days)
          start_times.push(dt.start_time)
          end_times.push(dt.end_time)
        end

        course[:days] = days
        course[:start_times] = start_times
        course[:end_times] = end_times

        course
      end
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