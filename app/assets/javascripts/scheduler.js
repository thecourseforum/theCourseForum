var testCourse = {
	title: 'CS 2150',
	professor: 'Bloomfield',
	startTime: '12:00:00',
	endTime: '12:50:00',
	days: ['Mo', 'Wed', 'Fr']
};

//{title: 'CS 2150', start: '2014-04-09 12:00:00', end: '2014-04-09 12:30:00', allDay: false}
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
/*$('#schedule').fullCalendar({
    events: [
        {
            title  : 'event1',
            start  : '2014-04-09'
        },
        {
            title  : 'event2',
            start  : '2014-04-08'
        },
        {
            title  : 'event3',
            start  : '2014-04-10 12:30:00',
            allDay : false // will make the time show
        }
    ]
});*/

$('.fc-header-right').css('visibility', 'hidden');

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
		console.log(event);
	};
	schedule.fullCalendar('refetchEvents');
}

addClasses(testCourse);