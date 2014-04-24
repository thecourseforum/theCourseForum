$(document).ready(function() {

  var results = [];


  //start format is '2014-04-07 12:00'
  var scheduledCourses = [];

  var schedule = $('#schedule');

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
  	else if(weekDay == 'We')
  		dateString += '09';	
  	else if(weekDay == 'Th')
  		dateString += '10';	
  	else if(weekDay == 'Fr')
  		dateString += '11';
  	return dateString;
  };


  function addClasses(course) {
  	var dateString;
  	if(course.events.length == 0) {
  		for (var i = 0; i < course.days.length; i++) {
  			dateString = getDateString(course.days[i])
  			var event = {
  				start:  dateString + ' ' + course.start_times[i],
  				end: dateString + ' ' + course.end_times[i],
  			};
  			event.__proto__ = course;
  			course.events.push(event);
  			scheduledCourses.push(event);
  		}
  	}
  	else {
  		for (var i = 0; i < course.events.length; i++) {
  			scheduledCourses.push(course.events[i]);
  		};
  	}
  	schedule.fullCalendar('refetchEvents');
  	$('.fc-event').mouseup(courseViewClick);
  }

  $('#class-search').keyup(function(key) {
  	if(key.keyCode == 13) { //if key is enter key
  		courseSearch($(this).val());
  	}
  });

  function courseSearch(courseno) {
  	jQuery.ajax('scheduler/search', {
  		data: {
  			course: courseno
  		},
  		success: function(response) {
  			for(var i = 0; i < response.length; i++) {
          if ( scheduledCourses.filter(function(result) {
            return result.section_id == response[i].section_id }).length == 0
            && !inResultsBox(response[i]) && response[i] != " ")
            //response[i] is a string of a single space if the controller
            //renders nothing (i.e. course doesn't exist/invalid input)
          {
  				  results.push(response[i]);
  				  displayResult(response[i]);
          }
  			}
  		}
  	})
  };

  function inResultsBox(section)
  {
    var children = $('#results-box').children()

    for(var i = 0; i < children.length; i++)
    {
      if (children[i].id == section.section_id)
      {
        return true;
      }
    }

    return false;
  }

  function displayResult(result) {
  	var resultBox = $('.course-result.hidden').clone().removeClass('hidden');
  	resultBox.children('.course-title').text(result.title);
  	resultBox.children('.professor').text(result.professor);
  	resultBox.children('.location').text(result.location);
  	var timeString = getTimeString(result);
  	resultBox.children('.time').text(timeString);
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

  function getTimeString(course){
    var timeString = course.start_times[0];
    var daysString = course.days[0];
    for(var i = 0; i < course.start_times.length; i++){
    	if(course.start_times[i] == course.start_times[i+1]){
      	timeString = formatTime(course.start_times[i]);
      	i++;
    		timeString += " - ";
      	timeString += formatTime(course.end_times[i]);
      }
      daysString += course.days[i];
    }
    return daysString + " " + timeString;
  }

  function formatTime(time)
  {
    var timeArray = time.split(":");
    if(parseInt(timeArray[0],10) < 12)
    {
      return time + "AM"
    }
    else
    {
      if (parseInt(timeArray[0],10) == 12)
      {
        return time + "PM"
      }
      else
      {
        return parseInt(timeArray[0],10)-12 + ":" + timeArray[1] + "PM"
      }    
    }
  }

  function displayInfo(result, eventView) {
      $('#info-box').empty();
      var infoBox = $('.course-info.hidden').clone().removeClass('hidden');
      infoBox.children('.course-title').text(result.title);
      infoBox.children('.professor').text(result.professor.split(" ")[1]);
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
      	left: '-7px',
      	display: 'block',
      	'width': eventView.width()
      });
      infoBox.children('button').mousedown(removeButtonClick);
      infoBox.children('button').attr('section_id', result.section_id);
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
  		$(this).remove();
  		var id = $(this).attr('id');
      if (scheduledCourses.filter(function(result){ return result.section_id == id}).length == 0)
      {
        var course = results.filter(function(result) {
          return result.section_id == id;
        })[0];
        if (course)
        {
          addClasses(course);
          removeCourseFromResults(id);
        }
        else
        {
          alert(id);
        }
      }  		
  	}
  }

  function removeCourseFromResults(id)
  {
    for(var i = 0; i < results.length; i++)
    {
      if (results[i].section_id == id)
      {
        results.splice(i, 1);
        return true;
      }
    }

    return false;
  }

  var eventBox;
  function courseViewClick() {
  	if(!mouseInDialog) {
  		eventBox = $(this);	
  	}
  }

  function courseEventClick(calEvent, jsEvent, view) {
  	if(!mouseInDialog && $('.course-info-dialog') != $('.course-info-dialog.hidden')) {
  		displayInfo(calEvent, eventBox);
  	}
  }

  function removeEvents(id) {
  	scheduledCourses = scheduledCourses.filter(function (element) { element.section_id == id; });
  	schedule.fullCalendar('removeEvents', function (event) { return event.section_id == id; });
  }

  var mouseInDialog = false;
  function dialogMouseOver(obj) {
  	mouseInDialog = true;
  }

  function dialogMouseOut(obj) {
  	mouseInDialog = false;
  }

  $(document).mouseup(function() {
  	if(!mouseInDialog) {
  		$('.course-info-dialog').remove();
  		mouseInDialog = false;
  	}
  });

  function removeButtonClick() {
  	removeEvents($(this).attr('section_id'));
  	$('#' + $(this).attr('section_id')).removeClass('hidden');
  }

});