// Used to switch between current semester and all courses
// Also used to switch between current semester and all professors when viewing a single course
function ready() {
	$(window.location.search != '' ? '#all' : '#current').parent().addClass('active');

	$('#current').change(function() {
		if (window.location.search != '') {
			Turbolinks.visit(window.location.pathname);
			// window.location.href = window.location.pathname;
		}
	});

	$('#all').change(function() {
		if (window.location.search == '') {
			Turbolinks.visit(window.location.pathname + '?all=true');
			// window.location.href = window.location.pathname + '?all=true';
		}
	});
}

$(document).ready(ready);

$(document).on('page:load', ready);