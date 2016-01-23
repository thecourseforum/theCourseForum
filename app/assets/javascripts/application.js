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
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.touch-punch
//= require jquery.slick
//= require turbolinks
//= require bootstrap
//= require jquery.readyselector
//= require moment
//= require fullcalendar
//= require jqcloud
//= require bootstrap-switch
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require highcharts
//= require highcharts/highcharts-more
// require new_wheel
//= require header
//= require courses
//= require departments
//= require contact_us
//= require sign_up
//= require reviews
//= require textbook_transactions
//= require sidebar

NProgress.configure({ showSpinner: false });

var ready = function() {
	$("#close-notice, #close-alert").click(function() {
		$(this).parent().slideUp();
	});

	$("#word-cloud-switch").bootstrapSwitch({
		size: 'small',
		onColor: 'primary',
		onSwitchChange: function(event, state) {
			if (state) {
				$.ajax({
					url: '/word_cloud_on/',
					type: 'POST'
				});
				$("#doge-switch").bootstrapSwitch('disabled', false);
			} else {
				$.ajax({
					url: '/word_cloud_off/',
					type: 'POST'
				});
				$("#doge-switch").bootstrapSwitch('state', false, true);
				$("#doge-switch").bootstrapSwitch('disabled', true);
			}
		}
	});

	$("#doge-switch").bootstrapSwitch({
		size: 'small',
		onColor: 'primary',
		onText: 'wow',
		onSwitchChange: function(event, state) {
			if (state) {
				$.ajax({
					url: '/doge_on/',
					type: 'POST'
				});
			} else {
				$.ajax({
					url: '/doge_off/',
					type: 'POST'
				});
			}
		}
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