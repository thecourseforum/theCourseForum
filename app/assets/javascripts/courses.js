var ready;

ready = function() {
	var params, search;
	if (window.location.search != '') {
		search = window.location.search.substring(1);
		params = JSON.parse('{"' + search.replace(/=/g, '":"').replace(/&/g, '","') + '"}');
		if (params['p']) {
			$('#check-' + params['p']).prop('checked', true);
		}
	}
	$('input[name=professor-id]').change(function() {
		var course_id, professor_id;
		course_id = window.location.pathname.split('/')[2];
		professor_id = $("input[name='professor-id']:checked").attr('id').split('-')[1];
		Turbolinks.visit('/courses/' + course_id + '?p=' + professor_id);
	});

	$('.courses-review-type-switcher').change(function() {
		Turbolinks.visit('/courses/' + $(this).val());
	});

	$('#save-course').click(function() {
		var course_name = $('#course-name').text().replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		course_name = course_name.split(' - ');
		course_name = course_name[0].split(' ');

		$.ajax('/scheduler/course', {
			method: "POST",
			data: {
				mnemonic: course_name[0],
				course_number: course_name[1]
			},
			success: function(response) {
				alert('Course saved for scheduler!');
			},
			failure: function(response) {
				alert('Could not load corresponding course!');
			}
		});
	});

	//hides the professors list on course page when the professor list is clicked
	var toggled = true;
	$("#courses-sidebar").click(function(){
		if(toggled) {
			toggled = false;
			$(this).hide({ left: "0px" });
			$("#courses-main").removeClass('col-xs-9').addClass('col-xs-12');

		} else {
			toggled = true;
			$(this).show({right: '200px'});
			$("#courses-main").removeClass('col-xs-12').addClass('col-xs-9');
		}
	});

	//If enter button is pressed, hide professors list
	$(document).keypress(function(e) {
		if(e.which == 13) {
			$('#courses-sidebar').click();
		}
	});

	$("#courses-sidebar").css("height", $("#courses-main").height());
};

$(document).ready(ready);

$(document).on('page:load', ready);