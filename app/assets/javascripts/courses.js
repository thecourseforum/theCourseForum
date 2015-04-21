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
		return window.location.href = '/courses/' + course_id + '?p=' + professor_id;
	});
		$('.courses-review-type-switcher').change(function() {
		return window.location.href = '/courses/' + $(this).val();
	});
	$('#save-course').click(function() {
		var course_name = $('#course-name').text().replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		course_name = course_name.split(' - ');
		course_name = course_name[0].split(' ');
		console.log("click");

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
};

$(document).ready(ready);

$(document).on('page:load', ready);