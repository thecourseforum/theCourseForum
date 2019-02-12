// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

NProgress.configure({ showSpinner: false });

var ready = function() {
	$("#close-notice, #close-alert").click(function() {
		$(this).parent().slideUp();
	});

	var input = [],
		konami = "38,38,40,40,37,39,37,39,66,65";

	//The following function sets a timer that checks for user input. You can change the variation in how long the user has to input by changing the number in ‘setTimeout.’ In this case, it’s set for 500 milliseconds or ½ second.
	$(document).keyup(function(e) {
		input.push(e.keyCode);
		if (input.toString().indexOf(konami) >= 0) {
			$(document).unbind('keydown', arguments.callee);
			alert('What did Alan the plate say to the other plate? Dinners on me.');
			input = [];
		}
	});

};
$(document).ready(ready);
$(document).on('page:load', ready);
