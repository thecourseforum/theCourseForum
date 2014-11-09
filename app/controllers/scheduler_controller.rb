class SchedulerController < ApplicationController

  require 'icalendar/tzinfo'

	def manual
    # calls export_ics if .ics is appended to the url (otherwise no special action)
    respond_to do |format|
      format.html
      format.ics {export_ics}
    end
	end

  def automatic
  end

	def search_sections
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

  def search_course
    unless params[:mnemonic] and params[:course_number]
      render :nothing => true, :status => 404 and return
    else
      subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
      course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept
      
      render :nothing => true, :status => 404 and return unless course

      render :json => course.as_json.merge({
        :course_mnemonic => "#{params[:mnemonic].upcase} #{params[:course_number]}",
        :lectures => rsections_to_jssections(course.sections.where(:semester_id => Semester.now.id, :section_type => 'Lecture')),
        :discussions => rsections_to_jssections(course.sections.where(:semester_id => Semester.now.id, :section_type => 'Discussion')),
        :laboratories => rsections_to_jssections(course.sections.where(:semester_id => Semester.now.id, :section_type => 'Laboratory'))
      }) and return
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
    if params[:course_sections]
      course_sections = JSON.parse(params[:course_sections]).map do |course|
        course.map do |section_id|
          Section.find(section_id)
        end
      end 
    else
      course_sections = []
      current_user.courses.each do |course|
        sections = course.sections.where(:semester_id => Semester.now.id).pluck(:section_type).uniq.map do |type|
          course_sections << course.sections.where(:section_type => type, :semester_id => Semester.now.id).flatten
        end
      end
    end

    # Permute through the array of arrays to generate all possible combinations of schedules
    # http://stackoverflow.com/questions/5582481/creating-permutations-from-a-multi-dimensional-array-in-ruby
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
        :location => section.locations.empty? ? 'NA' : section.locations.first.location,
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

  # takes a section, and turns each of its days into an iCal event
  # stores those events into an array 
  # each event (day) will be repeated weekly
  def render_ical_event(section)
    
      events = [] #array to hold all the days in a section (MWF are 3 separate events that repeat weekly)
      tzid = "America/New_York" # time zone

      # loop through each day of the section
      section.day_times.sort_by{|s| [s.start_time, s.end_time, day_to_number(s.day)] }.each do |day_time|

        event = Icalendar::Event.new

        # Create the start and end DateTimes
        firstMondayOfClasses = 12 # classes start monday Jan 12, 2015 
        eventDate = firstMondayOfClasses + day_to_number(day_time.day) # add the day of the week to the first day to get the date

        # Break the start_time format (18:00) into hour and minutes
        startTimeString = day_time.start_time
        startTimeString[":"] = "" #remove the colon
        (startTimeString.to_i >= 1000) ? startingHour = startTimeString.slice(0,2) : startingHour = startTimeString.slice(0, 1) #character size of hour will vary
        startingMinutes = startTimeString.slice(startTimeString.size-2, 2) # the minutes are always the last two chars

        # Do the same for the end time
        endTimeString = day_time.end_time
        endTimeString[":"] = ""
        (endTimeString.to_i >= 1000) ? endingHour = endTimeString.slice(0,2) : endingHour = endTimeString.slice(0,1)
        endingMinutes = endTimeString.slice(endTimeString.size-2, 2)

        # Construct DateTime objects using the above values
        event_start = DateTime.new(2015, 1, eventDate, startingHour.to_i, startingMinutes.to_i, 1) #seconds have to be something otherwise it doesn't add? (weird af)
        event_end = DateTime.new(2015, 1, eventDate, endingHour.to_i, endingMinutes.to_i, 1)

        # assign this to event's start and end fields along with the timezone
        event.dtstart = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
        event.dtend   = Icalendar::Values::DateTime.new event_end, 'tzid' => tzid

        #other event fields
        event.summary = "#{section.course.subdepartment.mnemonic} #{section.course.course_number}"
        event.description = "#{section.course.subdepartment.mnemonic} #{section.course.course_number}"
        event.location = section.locations.first.location
        event.rrule = "FREQ=WEEKLY;UNTIL=20150428T000000Z" #repeats once a week until hardcoded course end date (could do COUNT= if num occurences is known)

        #other unused fields
        #event.klass
        #event.created
        #event.last_modified
        #event.uid
        #event.add_comment = "created from theCourseForum.com!?"

        #adds the day for that section into an array
        events << event

      end 
      
      return events
  end

  # creates a calendar. loops through the saved sections.
  # turns each one as an ical event using render_ical_event
  # adds them to the calendar. publishes that calendar as a file
  def export_ics
    @calendar = Icalendar::Calendar.new
    # tzid = "America/New_York"
    # tz = TZInfo::Timezone.get tzid
    # timezone = tz.ical_timezone event.dtstart
    # @calendar.add_timezone timezone

    sections = current_user.sections
    sections.each do |section|
      events = render_ical_event(section)
      events.each do |event|
        @calendar.add_event(event)
      end  
    end

    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.to_ical

  end


end  