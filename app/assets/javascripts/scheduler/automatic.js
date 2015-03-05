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

	var searchResults = {},
		calendarCourses = [],
		schedules = [],
		savedSelections = [],
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
		year: 2014,
		month: 3,
		date: 14
	});

	$('.fc-toolbar').css('visibility', 'hidden'); //hides buttons

	$('#class-search').keyup(function(key) {
		if (key.keyCode == 13) { //if key is enter key
			courseSearch($(this).val());
		}
	});

	// Hide headers when Modal is closed
	$('#course-modal').on('hidden.bs.modal', function (e) {
  		hideHeaders();
	});

	$('#saved-courses').change(function() {
		var course = $.trim($('#saved-courses option:selected').text());
		if (course !== '-- Select Course --') {
			courseSearch(course);
		}
	});

	$('#save-selection').click(function() {
		var lecture_ids = [],
			discussion_ids = [],
			laboratory_ids = [];

		$('.lectures').children(':checked').each(function(index, element) {
			lecture_ids.push(parseInt(element.name));
		});

		$('.discussions').children(':checked').each(function(index, element) {
			discussion_ids.push(parseInt(element.name));
		});

		$('.laboratories').children(':checked').each(function(index, element) {
			laboratory_ids.push(parseInt(element.name));
		});

		searchResults[$('#course-title').attr('course_id')]['lectures'] = lecture_ids;

		searchResults[$('#course-title').attr('course_id')]['discussions'] = discussion_ids;

		searchResults[$('#course-title').attr('course_id')]['laboratories'] = laboratory_ids;

		$('#course-modal').modal('hide');

		console.log(searchResults);

		// //passes all checked sections to a controller method that will put them in a user table user_section
		// //Need a way to remove newly unchecked sections
		// $.ajax('/scheduler/save_selections', {
		// 	type: 'POST',
		// 	data: {
		// 		sections: sections
	 // 	 	},
	 // 	 	success: function(response) {
		// 		hideHeaders();
	 // 	 	}
	 // 	});

	});

	$('#schedule-slider').change(function() {
		$('#clear-sections').click();
		console.log($(this));
		loadSchedule(schedules[$(this).val()]);
	});

	function courseSearch(course) {
		if (course === '') {
			searchResults = {};
			resultBox.empty();
		} else {
			// Split the course search string (i.e. CS 2150) into two portions
			course = course.split(' ');
			$.ajax('scheduler/search_course', {
				// mnemonic - "CS"
				// course_number - "2150"
				data: {
					mnemonic: course[0],
					course_number: course[1]
				},
				success: function(response) {
					searchResults[response.id] = {
						'lectures': [],
						'discussions': [],
						'laboratories': []
					};
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
			delete searchResults[result.id];
			$(this).parent().remove();			
		});

		resultBox.mouseup(function(event) {
			$('#course-title').text(result.title);
			$('#course-title').attr('course_id', result.id);
			$('.lectures').empty();
			$('.discussions').empty();
			$('.laboratories').empty();

			//Updated way of restoring checks to checkboxes
			//matched against array from above

			if (result.lectures.length > 0) {
				$("#lecture-header").show();
				for(var i = 0; i < result.lectures.length; i++) {
					isChecked="";
					if (sectionSelected(result.lectures[i].section_id, result.id, 'lectures')) {
						isChecked = "checked";
					}
					$('.lectures').append('<input type="checkbox" ' + isChecked + ' name="' + result.lectures[i].section_id + '"> ');

					// if (searchResults[result.id]['lectures'] && searchResults[result.id]['lectures'].indexOf(result.lectures[i].section_id) != -1) {
					// 	$('.lectures').append('<input type="checkbox" checked name="' + result.lectures[i].section_id + '"> ');
					// } else {
					// 	$('.lectures').append('<input type="checkbox" name="' + result.lectures[i].section_id + '"> ');
					// }

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
					isChecked = "";
					if (sectionSelected(result.lectures[i].section_id, result.id, 'discussions')) {
						isChecked = "checked";
					}
					$('.discussions').append('<input type="checkbox" ' + isChecked + ' name="' + result.discussions[i].section_id + '"> ');

					// if (searchResults[result.id]['discussions'] && searchResults[result.id]['discussions'].indexOf(result.discussions[i].section_id) != -1) {
					// 	$('.discussions').append('<input type="checkbox" checked name="' + result.discussions[i].section_id + '"> ');
					// } else {
					// 	$('.discussions').append('<input type="checkbox" name="' + result.discussions[i].section_id + '"> ');
					// }

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
					isChecked = "";
					if (sectionSelected(result.lectures[i].section_id, result.id, 'laboratories')) {
						isChecked = "checked";
					}
					$('.laboratories').append('<input type="checkbox" ' + isChecked + ' name="' + result.laboratories[i].section_id + '"> ');

					// if (searchResults[result.id]['laboratories'] && searchResults[result.id]['laboratories'].indexOf(result.laboratories[i].section_id) != -1) {
					// 	$('.laboratories').append('<input type="checkbox" checked name="' + result.laboratories[i].section_id + '"> ');
					// } else {
					// 	$('.laboratories').append('<input type="checkbox" name="' + result.laboratories[i].section_id + '"> ');
					// }
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
		resultBox.children(':checkbox').attr('name', result.id);
		resultBox.children(':checkbox').change(function() {
			var sections = [],
				course_ids = [];
			$('.course-result').children(':checked').each(function(index, element) {
				course_ids.push(parseInt(element.name));
			});

			for (var i = 0; i < course_ids.length; i++) {
				course = course_ids[i];
				if (searchResults[course]['lectures'] && searchResults[course]['lectures'].length > 0) {
					sections.push(searchResults[course]['lectures']);
				}
				if (searchResults[course]['discussions'] && searchResults[course]['discussions'].length > 0) {
					sections.push(searchResults[course]['discussions']);
				}
				if (searchResults[course]['laboratories'] && searchResults[course]['laboratories'].length > 0) {
					sections.push(searchResults[course]['laboratories']);
				}
			}
			$.ajax('schedules', {
				data: {
					course_sections: JSON.stringify(sections)
				},
				success: function(response) {
					schedules = response;
					$('#schedule-slider').attr('max', schedules.length - 1);
					$('#schedule-slider').change();
				}
			});
		});
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
			}
		}
		schedule.fullCalendar('removeEvents');
		schedule.fullCalendar('addEventSource', $.merge([], calendarCourses));
	}

	function loadSchedule(schedule) {
		for (var i = 0; i < schedule.length; i++) {
			console.log("test");
			addClass(schedule[i]);
		}
	}

	function loadSelections(selections) {
		savedSelections.length = 0;
		for (var i = 0; i < selections.length; i++) {
			//console.log(selections[i]);
			savedSelections[savedSelections.length] = (selections[i]);
		}
		console.log(savedSelections);
	}

	// checks if  section has been saved so that it can be marked as checked
	function sectionSelected(section_id, course_id, type) {
		return searchResults[course_id][type].indexOf(section_id) != -1;
	}

});