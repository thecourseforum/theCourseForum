//sample course format
var testCourse = {
	title: 'CS 2150',
	professor: 'Bloomfield',
	startTime: '12:00:00',
	endTime: '12:50:00',
	days: ['Mo', 'Wed', 'Fr']
};

//start format is '2014-04-07 12:00:00'
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
			allDay: false
		};
		event.prototype = course;
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
		var results = [testCourse];
		for (var i = results.length - 1; i >= 0; i--) {
					addClasses(results[i]);
		};		
	}
};