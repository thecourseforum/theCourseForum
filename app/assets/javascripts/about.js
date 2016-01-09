var ready;

ready = function() {

	$('.block').hover(
		function() { $(this).find('.ushover').fadeIn(); },
		function() { $(this).find('.ushover').fadeOut(); }
		);
}

$(document).ready(ready);
$(document).on('page:load', ready);