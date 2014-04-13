//sample course format
var results = [{
	section_id: '12345',
	title: 'CS 2150',
	professor: 'Bloomfield',
	location: 'Olsson 120',
	start_times: ['14:00', '14:00', '14:00'],
	end_times: ['14:50','14:50','14:50'],
	allDay: false,
	days: ['Mo', 'Wed', 'Fr'],
	//daysArr: this.days.split(/(?=[A-Z])/)
}];


//start format is '2014-04-07 12:00'
var scheduledCourses = [];

var schedule = $('#schedule');

schedule.fullCalendar({
    defaultView: 'agendaWeek',
    weekends: false,
    firstHour: 8,
    allDaySlot: false,
    columnFormat: {
    	agendaWeek: 'dddd'
    },
    titleFormat: {
    	agendaWeek: 'yyyy'
    },
    contentHeight: 610,
    events: scheduledCourses,
    eventClick: courseEventClick,
    year: 2014,
    month: 3,
    date: 7
});
$('.fc-header-right').css('visibility', 'hidden'); //hides buttons

//gets a day corresponding to the given weekDay
function getDateString(weekDay) {
	var dateString = '2014-04-';
	if(weekDay == 'Mo')
		dateString += '07';
	else if(weekDay == 'Tu')
		dateString += '08';	
	else if(weekDay == 'Wed')
		dateString += '09';	
	else if(weekDay == 'Tr')
		dateString += '10';	
	else if(weekDay == 'Fr')
		dateString += '11';
	return dateString;
};


function addClasses(course) {
	var dateString;
	for (var i = course.days.length - 1; i >= 0; i--) {
		dateString = getDateString(course.days[i])
		var event = {
			start:  dateString + ' ' + course.start_times[i],
			end: dateString + ' ' + course.end_times[i],
		};
		event.__proto__ = course;
		scheduledCourses.push(event);
	};
	schedule.fullCalendar('refetchEvents');
	$('.fc-event').mouseup(courseViewClick);
}

$('#class-search').keyup(function(key) {
	if(key.keyCode == 13) { //if key is enter key
		courseSearch($(this).val());
	}
});

function courseSearch(courseno) {
	//fetch results
	//display results
	if(courseno == 'cs2150') {
		for (var i = results.length - 1; i >= 0; i--) {
					displayResult(results[i]);
		};
	}
};

function displayResult(result) {
	var resultBox = $('.course-result.hidden').clone().removeClass('hidden');
	resultBox.children('.course-title').text(result.title);
	resultBox.children('.professor').text(result.professor);
	resultBox.children('.location').text(result.location);
	resultBox.children('.time').text(result.startTime + ' - ' + result.endTime + ' ' + result.days.join(''));
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
	resultBox.attr('id', result.section_id);
	$('#results-box').append(resultBox);
};

function displayInfo(result, eventView) {
    $('#info-box').empty();
    var infoBox = $('.course-info.hidden').clone().removeClass('hidden');
    infoBox.children('.title').text(result.title);
    infoBox.children('.professor').text(result.professor);
    infoBox.children('.description').text(result.description);
    infoBox.children('.location').text(result.location);
    infoBox.mouseover(dialogMouseOver);
    infoBox.mouseout(dialogMouseOut);
    infoBox.addClass('course-info-dialog');
    infoBox.mouseup(function(event) {
    	infoBox.remove();
    	mouseInDialog = false;
    });
    eventView.append(infoBox);
    infoBox.css({
    	position: 'relative',
    	top: (-25 - infoBox.height() - eventView.height()) + 'px',
    	left: '0px',
    	display: 'block',
    	'max-width': eventView.width()
    });
}

function getPos($obj) {
	return {
		xPos: Math.floor($obj.offset().left + $obj.width() / 2),
		yPos: Math.floor($obj.offset().top + $obj.height() / 2)
	};
}

function resultRelease(eventObj) {
	var position = getPos($(this));
	if(position.xPos > schedule.offset().left && position.xPos < schedule.offset().left + schedule.width()
				&& position.yPos > schedule.offset().top && position.yPos < schedule.offset().top + schedule.height()) {
		$(this).addClass('hidden');
		var id = $(this).attr('id');
		addClasses(results.filter(function(result) {
			return result.section_id == id;
		})[0]);
	}
}

var eventBox;
function courseViewClick() {
	if(!mouseInDialog) {
		eventBox = $(this);	
	}
}

function courseEventClick(calEvent, jsEvent, view) {
	if(!mouseInDialog && $('.course-info-dialog') != $('.course-info-dialog.hidden')) {
		displayInfo(results.filter(function(result) {
			return calEvent.section_id == result.section_id;
		})[0], eventBox);
	}
}

var mouseInDialog = false;
function dialogMouseOver(obj) {
	mouseInDialog = true;
}

function dialogMouseOut(obj) {
	mouseInDialog = false;
}

$(document).mouseup(function() {
	if(!mouseInDialog)
		$('.course-info-dialog').remove();
});
