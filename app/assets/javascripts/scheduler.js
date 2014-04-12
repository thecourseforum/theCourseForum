$('#schedule').fullCalendar({
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
    contentHeight: 610
    //aspectRatio: 2
});

$('.fc-header-right').css('visibility', 'hidden');
