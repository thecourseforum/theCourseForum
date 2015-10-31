var ready;

ready = function() {

	$('.block').hover(function() {
	        //$(this).find('.usmain').fadeOut(50);
	        $(this).find('.ushover').fadeIn();
	    }, function() {
	        $(this).find('.ushover').fadeOut();
	        //$(this).find('.usmain').show();
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);