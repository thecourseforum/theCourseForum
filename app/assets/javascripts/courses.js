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
	return $('.courses-review-type-switcher').change(function() {
		return window.location.href = '/courses/' + $(this).val();
	});
};

$(document).ready(ready);

$(document).on('page:load', ready);