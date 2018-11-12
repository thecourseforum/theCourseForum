// All JavaScript needs to be loaded after the page has been rendered
// This is to ensure proper selection of DOM elements (jquery + bootstrap expansion)

// $ denotes jQuery - $(document) means we select the "document" or HTML page object
// We attach an anonymous function to be executed when the page is "ready" - all DOM elements are loaded


$(document).ready(function() {
    //$('#calendar').css('width', $('#search-bar').parent().css('width').split('p')[0] - $('#search-bar').css('width').split('p')[0] - 20);

    // Utility class to format strings for display
    var Utils = {
        // Converts date into a day of the week, using our base week reference of April - XX - 2015
        formatDateString: function(weekDay) {
            // Days of the week placeholder array
            var days = ['Mo', 'Tu', 'We', 'Th', 'Fr'],
                // Reference month defined (April 2014)
                dateString = '2014-04-';

            // Append to the date the selected day of the week - If monday, then date is 2014-04-14 (a Monday)
            dateString += (days.indexOf(weekDay) + 14);

            // Finally, return the date that corresponds to the passed in weekDay
            return dateString;
        },

        // Performs initial formatting from start time and end times to legible format
        // Responsible for output of: Mo 12:00PM - 1:45PM
        // Takes in a Course object, which has nested start_times and end_times in separate array properties
        // Will "pair" these start_times and end_times together
        formatTimeStrings: function(course) {
            // Placeholder array for pairs of start_times and end_times
            var times = [],
                // Initial string for the day - Mo, or Tu
                daysString = "",
                // Initial string for the time - 12:00PM - 1:45 PM
                timeString = "";

            // Each start_time corresponds to a separate day, stored in course.days or course['days']
            for (var i = 0; i < course.start_times.length; i++) {
                // Begin the time string with the corresponding day
                daysString += course.days[i];

                // Test if start_time is repeated twice
                // !== will also test for undefined cases, i.e. 4 === undefined will be false
                if (course.start_times[i] !== course.start_times[i + 1] || course.end_times[i] !== course.end_times[i + 1]) {
                    // Takes in input time of 08:00 and call Utils.formatTime to return human readable time for start time
                    timeString = this.formatTime(course.start_times[i]);
                    // Hyphen to separate start_time and end_time
                    timeString += " - ";
                    // Takes in input time of 08:00 and call Utils.formatTime to return human readable time for end time
                    timeString += this.formatTime(course.end_times[i]);

                    // Finally, append the complete string to placeholder array (times)
                    times.push(daysString + " " + timeString);
                    // Re-initialize dayString for the next iterative loop
                    daysString = "";
                }

            }

            // Finally, return the array of time pairs
            return times;
        },

        // Transforms "08:00" to 8:00AM and "13:45" to 1:45PM
        formatTime: function(time) {
            // Split incoming argument by colon, so "08:00" becomes ["08", "00"]
            var timeArray = time.split(":"),
                // Grab the first element (hour) and parse into int
                // Second argument (10) specifies what base we are in
                hour = parseInt(timeArray[0], 10);

            // Less than 12 hours, we are in the morning
            if (hour < 12) {
                // Can return original time, plus AM
                // LOOKAT
                // Actually, this is a little weird - don't know how it turns 08:00 to 08:00AM or 8:00AM
                return hour + ":" + timeArray[1] + "AM";
            } else if (hour == 12) {
                // If noon, then again like previous case just append PM to original string
                return time + "PM";
            } else {
                // Subtract twelve from hour, re-append minutes to it, then "PM"
                return hour - 12 + ":" + timeArray[1] + "PM";
            }
        },
        colorList : [
            '#546de5',
            '#e15f41',
            '#574b90',
            '#ff3838',
            '#2ecc71',
            '#c56cf0',
            '#f19066',
            '#ffd32a',
            '#38ada9',
        ],
        colorCounter : 0,

        // Generate random color
        getColor: function() {
            var color = this.colorList[this.colorCounter];
            this.colorCounter = (this.colorCounter + 1) % this.colorList.length;
            return color;
        }

    }

    // searchResults is a DIRECT representation of courses (and selected sections) below the search box
    // searchResults is an OBJECT with the course_id as key to selected sections
    // selected sections are further broken down by lectures, discussions, and laboratories, which are arrays of section ids
    // selected flag asks if this course is selected to be included in schedule generation
    // sample representation of searchResults is as follows:
    // searchResults = {
    //  20382: {
    //      selected: false,
    //      units: 3
    //      lectures: [203955, 30291, 203432],
    //      discussions: [20392, 20395],
    //      laboratories: []
    //  }
    // }
    // In the above example, 20382 is course_id, and the arrays show SELECTED (or checked) sections that the user wants to generate schedules for
    // ANY logic changes to courses (selected sections, removing a course) MUST update this object!!
    var searchResults = {},

        // calendarCourses is a DIRECT representation of CALENDAR events
        // Clearing, adding, events must use this array of fullCalendar events!
        calendarCourses = [],
        savedSchedules = [],
        // schedules stores an array of potential schedules, which themselves are just an array of section objects
        schedules = [],
        courses = {},
        colorMap = {};


    $('#schedule').fullCalendar({
        // Default view for the calendar is agendaWeek, which shows a single week
        defaultView: 'agendaWeek',
        // No weekends for this view
        weekends: false,
        // Earliest time to be shown on the calendar is 8AM
        minTime: "08:00:00",
        // Latest time to be shown on the calendar is 10PM
        maxTime: "22:00:00",
        // Remove the box for showing potential all day events
        allDaySlot: false,
        columnFormat: {
            agendaWeek: 'ddd'
        },
        titleFormat: {
            agendaWeek: 'yyyy'
        },
        // Sets height of the plugin calendar
        contentHeight: "auto",
        // Initialize the calendar with this set of events (should be empty anyway)
        events: calendarCourses,


        eventRender: function(event, element) {
            $(element).popover({
                trigger: "hover",
                html: "true",
                placement: "auto top",
                title: "<strong>SIS ID: </strong>" + event.sis_id,
                content: 
                "<strong>Location: </strong>" + event.location
                + "<br><strong>Prof: </strong>" + event.professor,
            });
        },

        // New default date
        defaultDate: '2014-04-14',
        eventClick: function(calendarEvent) {
            $.ajax('/scheduler/course', {
                data: {
                    section_id: calendarEvent.section_id
                },
                success: function(response) {
                    window.open('/courses/' + response.course_id + '?p=' + response.professor_id, '_blank')
                },
                failure: function(response) {
                    alert('Could not load corresponding course!');
                }
            });
        }
    });


    // Asks server for schedule from section ids
    function searchSchedules() {
		$.ajax('/scheduler/coursedata?sl=' + window.location.pathname.split('/')[2], {
			success: function(response) {
				$("#course-name .page-title").html(response['owner'] + "'s schedule");
				loadSchedule(response['sections']);
			}		
		});
		
    }

    function displayResult(result) {
		if(courses[result.course_id] != 1){
			courses[result.course_id] = 1;
			var resultBox = $('.course-result.hidden').clone().removeClass('hidden');
			var content = resultBox.children('#content');
			content.children('.course-mnemonic').text(result.title);
			content.children('.course-title').text(result.name);
			$('#results-box').append(resultBox);
			sectionColor = Utils.getColor();
			colorMap[result.course_mnemonic] = sectionColor;
			content.css('background-color', sectionColor);
		}
    }

    function addClass(course) {
        var dateString;
		displayResult(course);
        if (course.events.length == 0) {
            for (var i = 0; i < course.days.length; i++) {
                dateString = Utils.formatDateString(course.days[i])
                var event = {
                    start: dateString + ' ' + course.start_times[i],
                    end: dateString + ' ' + course.end_times[i],
                };
                event.__proto__ = course;
                event.title = course.title + ' — ' + course.professor.split(' ')[course.professor.split(' ').length - 1];
                course.events.push(event);
                calendarCourses.push(event);
                event.color = colorMap[course.course_mnemonic];
            }
        } else {
            for (var i = 0; i < course.events.length; i++) {
                calendarCourses.push(course.events[i]);
            }
        }

        $('#schedule').fullCalendar('removeEvents');
        $('#schedule').fullCalendar('addEventSource', $.merge([], calendarCourses));
    }

    function loadSchedule(schedule) {
		calendarCourses = []
		var credits = 0;
        $('#schedule').fullCalendar('removeEvents');
        if (schedule) {
			for (var i = 0; i < schedule.length; i++){
				credits += 	parseInt(schedule[i].credits);
				addClass(schedule[i]);
			}
			$('#credits').text(credits + " credits");
        }
		
    }
	
	searchSchedules();

});


