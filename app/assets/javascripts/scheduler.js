//sample course format
var results = [{
	sectionID: '12345',
	title: 'CS 2150',
	professor: 'Bloomfield',
	location: 'Olsson 120',
	startTime: '14:00',
	endTime: '14:50',
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
    eventClick: courseClick,
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
			start:  dateString + ' ' + course.startTime,
			end: dateString + ' ' + course.endTime,
		};
		event.__proto__ = course;
		scheduledCourses.push(event);
	};
	schedule.fullCalendar('refetchEvents');
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
	resultBox.attr('id', result.sectionID);
	$('#results-box').append(resultBox);
};

function displayInfo(result) {
    $('#info-box').empty();
    var infoBox = $('.course-info.hidden').clone().removeClass('hidden');
    infoBox.children('.title').text(result.title);
    infoBox.children('.professor').text(result.professor);
    infoBox.children('.description').text(result.description);
    infoBox.children('.location').text(result.location);
    $('#info-box').append(infoBox);
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
			return result.sectionID == id;
		})[0]);
	}
}

function courseClick(calEvent, jsEvent, view) {
	displayInfo(results.filter(function(result) {
		return calEvent.sectionID == result.sectionID;
	})[0]);

}