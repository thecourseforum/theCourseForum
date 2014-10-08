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
			console.log(sections);
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

	var searchResults = [],
		calendarCourses = [],
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

	$(document).mouseup(function() {
		if (!mouseInDialog) {
			$('.course-info-dialog').remove();
			mouseInDialog = false;
		}
	});

	$('#saved-classes').change(function() {
		var course = $('#saved-classes option:selected').text();
		if (course !== '-- Select Class --') {
			courseSearch(course);
		}
	});

	$('#clear-saved').click(function() {
		$('#saved-classes')
			.find('option')
			.remove()
			.end()
			.append('<option value="-- Select Class --">-- Select Class --</option>')
			.val('-- Select Class --');

		$.ajax('scheduler/clear', {
			type: 'DELETE',
			success: function() {
				alert("Saved courses cleared!");
			}
		});
	});

	function courseSearch(course) {
		if (course === '') {
			searchResults = [];
			displayResults();
		} else {
			// Split the course search string (i.e. CS 2150) into two portions
			course = course.split(' ');
			$.ajax('scheduler/search', {
				// mnemonic - "CS"
				// course_number - "2150"
				data: {
					mnemonic: course[0],
					course_number: course[1]
				},
				success: function(response) {
					var calendarSections = calendarCourses.map(function(element) {
						return element.__proto__.section_id;
					});
					searchResults = $.grep(response, function(result) {
						return calendarSections.indexOf(result.section_id) == -1;
					});
					if (searchResults.length == 0) {
						alert('No classes found for this semester!');
					} else {
						displayResults();
					}
				},
				error: function(response) {
					alert("Improper search!");
				}
			});
		}
	};

	function displayResults() {
		$('#results-box').empty();
		for (var i = 0; i < searchResults.length; i++) {
			displayResult(searchResults[i]);
		}
	}

	function displayResult(result) {
		var resultBox = $('.course-result.hidden').clone().removeClass('hidden');
		resultBox.children('.remove').text('x');
		resultBox.children('.remove').css({
			"float": "right",
			"color": "white"
		});

		resultBox.children('.remove').click(function() {
			searchResults = $.grep(searchResults, function(course) {
				return result.section_id != course.section_id;
			});
			$(this).parent().remove();
			mouseInDialog = false;
		});

		resultBox.children('.course-title').text(result.title);
		resultBox.children('.professor').text(result.professor);
		resultBox.children('.location').text(result.location);

		var timeStrings = Utils.formatTimeStrings(result);

		for (var i = 0; i < timeStrings.length; i++) {
			var timeString = timeStrings[i];
			resultBox.append("<p class=time" + i + "></p>");
			resultBox.children('.time' + i).text(timeString);
		}

		resultBox.append("<p class=sisID></p>");
		resultBox.children('.sisID').text(result.section_id);

		resultBox.draggable({
			start: function(event, ui) {
				ui.helper.addClass('is-dragging');
			},
			stop: function(event, ui) {
				ui.helper.removeClass('is-dragging');
			},
			revert: true
		});
		resultBox.mouseup(resultRelease);
		resultBox.attr('section_id', result.section_id);
		$('#results-box').append(resultBox);
	}

	function resultRelease(eventObj) {
		var position = getPos($(this));
		if (position.xPos > schedule.offset().left && position.xPos < schedule.offset().left + schedule.width() && position.yPos > schedule.offset().top && position.yPos < schedule.offset().top + schedule.height()) {
			$(this).remove();
			addClass(Utils.findCourse(searchResults, $(this).attr('section_id')));
		}
	}

	function getPos($obj) {
		return {
			xPos: Math.floor($obj.offset().left + $obj.width() / 2),
			yPos: Math.floor($obj.offset().top + $obj.height() / 2)
		};
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
		var infoBox = $('.course-info.hidden').clone().removeClass('hidden');
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

	function removeButtonClick() {
		var section_id = $(this).attr('section_id');
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
});