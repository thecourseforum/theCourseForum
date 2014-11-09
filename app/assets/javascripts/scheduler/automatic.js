$(document).ready(function() {
	var Utils = {
		// Converts date into a day of the week
		formatDateString: function(weekDay) {
			var days = ['Mo', 'Tu', 'We', 'Th', 'Fr'],
				dateString = '2014-04-';

			dateString += (days.indexOf(weekDay) + 14);

			return dateString;
		},

		formatTimeStrings: function(course) {
			var result = "",
				times = [],
				daysString = "",
				timeString = "";

			for (var i = 0; i < course.start_times.length; i++) {
				daysString += course.days[i];

				if (course.start_times[i] !== course.start_times[i + 1] || course.end_times[i] !== course.end_times[i + 1]) {
					timeString = this.formatTime(course.start_times[i]);
					timeString += " - ";
					timeString += this.formatTime(course.end_times[i]);

					times.push(daysString + " " + timeString);
					daysString = "";
				}

			}
			return times;
		},

		formatTime: function(time) {
			var timeArray = time.split(":"),
				hour = parseInt(timeArray[0], 10);

			if (hour < 12) {
				return time + "AM";
			} else if (hour == 12) {
				return time = "PM";
			} else {
				return hour - 12 + ":" + timeArray[1] + "PM";
			}
		},

		containsCourse: function(courses, course) {
			var sections = courses.map(function(element) {
				element.section_id;
			});
			return sections.indexOf(course.section_id) != -1;
		},

		uniqueCourses: function(first, second) {
			var both = first.concat(second);
			return $.grep(both, function(course, index) {
				return both.indexOf(course) == index;
			});
		},

		findCourse: function(courses, section_id) {
			for (var i = 0; i < courses.length; i++) {
				if (courses[i].section_id == section_id) {
					return courses[i];
				}
			}
			return nil;
		}
	}

	function hideHeaders() {
		$("#lecture-header").hide();
		$("#discussion-header").hide();
		$("#laboratory-header").hide();
	}

	var searchResults = [],
		calendarCourses = [],
		schedules = [],
		schedule = $('#schedule'),
		mouseInDialog = false;

	schedule.fullCalendar({
		defaultView: 'agendaWeek',
		weekends: false,
		minTime: 8,
		maxTime: 22,
		allDaySlot: false,
		columnFormat: {
			agendaWeek: 'dddd'
		},
		titleFormat: {
			agendaWeek: 'yyyy'
		},
		contentHeight: 610,
		events: calendarCourses,
		eventClick: courseEventClick,
		year: 2014,
		month: 3,
		date: 14
	});

	$('.fc-header-right').css('visibility', 'hidden'); //hides buttons


	$('#class-search').keyup(function(key) {
		if (key.keyCode == 13) { //if key is enter key
			courseSearch($(this).val());
		}
	});

	// Hide headers when Modal is closed
	$('#course-modal').on('hidden.bs.modal', function (e) {
  	hideHeaders();
	})

	$('#save-sections').click(function() {
		var section_ids = calendarCourses.map(function(event) {
			return event.section_id;
		}),
			section_courses = calendarCourses.map(function(event) {
				return event.title;
			});

		var unique_sections = [];
		$.each(section_courses, function(i, el) {
			if ($.inArray(el, unique_sections) === -1) unique_sections.push(el);
		});

		$.ajax('scheduler/sections', {
			type: 'POST',
			data: {
				sections: JSON.stringify(section_ids)
			},
			success: function() {
				var saved_courses = [];
				$('#saved-courses option').each(function() {
					saved_courses.push($(this).text());
				});
				for (var i = 0; i < unique_sections.length; i++) {
					if (saved_courses.indexOf(unique_sections[i]) == -1) {
						$('#saved-courses').append('<option value="' + unique_sections[i] + '">' + unique_sections[i] + '</option>')
					}
				}
				alert("Sections saved!");
			}
		});
	});

	$('#saved-courses').change(function() {
		var course = $('#saved-courses option:selected').text();
		if (course !== '-- Select Course --') {
			courseSearch(course);
		}
	});

	function courseSearch(course) {
		if (course === '') {
			searchResults = [];
			displayResults();
		} else {
			// Split the course search string (i.e. CS 2150) into two portions
			course = course.split(' ');
			$.ajax('search_course', {
				// mnemonic - "CS"
				// course_number - "2150"
				data: {
					mnemonic: course[0],
					course_number: course[1]
				},
				success: function(response) {
					displayResult(response);
				},
				error: function(response) {
					alert("Improper search!");
				}
			});
		}
	}

	function displayResult(result) {
		var resultBox = $('.course-result.hidden').clone().removeClass('hidden');
		resultBox.children('.remove').text('x');
		resultBox.children('.remove').css({
			"float": "right",
			"color": "white"
		});

		resultBox.children('.remove').mouseup(function() {
			$(this).parent().remove();			
		});

		resultBox.mouseup(function(event) {
			$('#course-title').text(result.title);
			$('.lectures').empty();
			$('.discussions').empty();
			$('.laboratories').empty();
			if (result.lectures.length > 0) {
				$("#lecture-header").show();
				for(var i = 0; i < result.lectures.length; i++) {
					$('.lectures').append('<input type="checkbox"> ')
					$('.lectures').append(Utils.formatTimeStrings(result.lectures[i]));
					$('.lectures').append(", " + result.lectures[i].professor);
					if (i != result.lectures.length - 1) {
						$('.lectures').append("<br/>");
					}
				}
			}
			if (result.discussions.length > 0) {
				$("#discussion-header").show();
				for(var i = 0; i < result.discussions.length; i++) {
					$('.discussions').append('<input type="checkbox"> ')
					$('.discussions').append(Utils.formatTimeStrings(result.discussions[i]));
					$('.discussions').append(", " + result.discussions[i].professor);
					if (i != result.discussions.length - 1) {
						$('.discussions').append("<br/>");
					}
				}
			}
			if (result.laboratories.length > 0) {
				$("#laboratory-header").show();
				for(var i = 0; i < result.laboratories.length; i++) {
					$('.laboratories').append('<input type="checkbox"> ')
					$('.laboratories').append(Utils.formatTimeStrings(result.laboratories[i]));
					$('.laboratories').append(", " + result.laboratories[i].professor);
					if (i != result.laboratories.length - 1) {
						$('.laboratories').append("<br/>");
					}
				}
			}
			$('#course-modal').modal();
		});
		
		resultBox.children('.course-mnemonic').text(result.course_mnemonic);
		resultBox.children('.course-title').text(result.title);
		$('#results-box').append(resultBox);
	}

	function addClass(course) {
		var dateString;
		if (course.events.length == 0) {
			for (var i = 0; i < course.days.length; i++) {
				dateString = Utils.formatDateString(course.days[i])
				var event = {
					start: dateString + ' ' + course.start_times[i],
					end: dateString + ' ' + course.end_times[i],
				};
				event.__proto__ = course;
				course.events.push(event);
				calendarCourses.push(event);
			}
		} else {
			for (var i = 0; i < course.events.length; i++) {
				calendarCourses.push(course.events[i]);
			};
		}
		schedule.fullCalendar('removeEvents');
		schedule.fullCalendar('addEventSource', $.merge([], calendarCourses));
	}

	function displayInfo(result, eventView) {
		$('#info-box').empty();
		var infoBox = $('.course-info.hidden').clone().hide().removeClass('hidden').fadeIn();
		infoBox.children('.course-title').text(result.title);
		infoBox.children('.professor').text(result.professor.split(" ")[1]);
		infoBox.children('.description').text(result.description);
		infoBox.children('.location').text(result.location);
		infoBox.mouseover(function() {
			mouseInDialog = true;
		});
		infoBox.mouseout(function() {
			mouseInDialog = false;
		});
		infoBox.addClass('course-info-dialog');
		infoBox.mouseup(function(event) {
			infoBox.remove();
			mouseInDialog = false;
		});
		eventView.append(infoBox);
		infoBox.css({
			position: 'relative',
			top: (-25 - infoBox.height() - eventView.height()) + 'px',
			left: '-7px',
			display: 'block',
			'width': eventView.width()
		});
		infoBox.children('.remove').text('x');
		infoBox.children('.remove').css({
			"float": "right"
		});
		infoBox.children('.remove').hover(function() {
			$(this).css({
				"cursor": "pointer"
			});
		});
		infoBox.children('.remove').mousedown(removeButtonClick);
		infoBox.children('.remove').attr('section_id', result.section_id);
	}

	function loadSchedule(schedule) {
		for (var i = 0; i < schedule.length; i++) {
			addClass(schedule[i]);
		}
	}

	function removeButtonClick() {
		var section_id = $(this).attr('section_id');
		removeEvent(section_id);
	}

	function removeEvent(section_id) {
		calendarCourses = calendarCourses.filter(function(element) {
			return element.section_id != section_id;
		});
		schedule.fullCalendar('removeEvents', function(course) {
			return course.section_id == section_id;
		});
		mouseInDialog = false;
	}

	function courseEventClick(calEvent, jsEvent, view) {
		if (!mouseInDialog && $('.course-info-dialog') != $('.course-info-dialog.hidden')) {
			eventBox = $(this);
			displayInfo(calEvent, eventBox);
		}
	}

	$('#reset-sections').click();
});