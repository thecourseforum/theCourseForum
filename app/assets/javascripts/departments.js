// Used to switch between current semester and all courses
// Also used to switch between current semester and all professors when viewing a single course
var ready = function() {
	$('#current').change(function() {
		$('.all').slideUp();
	});

	$('#all').change(function() {
		$('.all').slideDown();
	});

	$('#browsing-content').parent().css({
        'box-shadow': 'none', 
        'background-color': '#eee',
    });
}

$(document).ready(ready);
$(document).on('page:load', ready);