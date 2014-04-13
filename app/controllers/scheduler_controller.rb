class SchedulerController < ApplicationController

	def ui
	end

	def search
    if params[:course] == nil
      render :nothing => true
      return
    else
      arr = params[:course].split(" ")
      mnemonic = arr[0].upcase
      course_number = arr[1]

      subdept_id = Subdepartment.find_by(mnemonic: mnemonic).id

      c = Course.find_by(subdepartment_id: subdept_id, course_number: course_number)

      sections = c.sections

      values = []

      sections.each do |section|
        course = {}

        course[:section_id] = section.sis_class_number
        course[:title] = "#{mnemonic} #{course_number}"
        course[:professor] = "TODO: CHANGE"
        course[:section_type] = section.section_type
        course[:location] = section.locations.first.location
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

        values.push(course)
      end    



  		respond_to do |format|
  			format.json { render json: values}
  		end
    end
	end

  def save
    section_id = params[:section_id]
    section = Sections.find(section_id)

    current_user.sections.push(section)

    render :nothing => true
  end

  def delete
    section_id = params[:section_id]
    section = Section.find(section_id)

    current_user.sections.remove(section)

    render :nothing => true
end