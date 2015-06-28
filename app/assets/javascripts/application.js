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
//= require turbolinks
//= require bootstrap
//= require d3
// require new_wheel
//= require header
//= require courses
//= require contact_us
//= require sign_up
//= require reviews
//= require moment
//= require fullcalendar
//= require jqcloud
//= require bootstrap-switch
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require highcharts
//= require highcharts/highcharts-more

var ready = function() {

	// Attatches navbar-toggle button to sidebar
	$('.navbar-toggle').click(function() {
		$('aside').toggle('slide', {
			direction: 'left'
		}, "fast");
	});

	// expands user-account options in sidebar on click
	$("a#user-account").click(function() {
		$(".col-secondary").toggle("fast");
	});

	$(document).mousedown(function(e) {
		// if click outside of sidebar, and window length is less than 850px, retract sidebar.
		if (!$("aside").is(e.target) && $("aside").has(e.target).length === 0 && $(window).width() < 850 && !$(".navbar-toggle").is(e.target)) {
			$("aside").hide('slide', "fast");
		}
	});

	// retracts sidebar if esc key is pressed
	$(document).keydown(function(e) {
		if (e.which === 27 && $(window).width() < 850) {
			$("aside").hide('slide', 'fast');
		}
	});

	$("#close-notice, #close-alert").click(function() {
		$(this).parent().slideUp();
	});

	$("#search-query").focus(function() {
		if ($("#search-query").val() == "") {
			$(".nav-row").each(function() {
				if (!($(this).hasClass("search-row"))) {
					$(this).slideUp();
				}
			});

			$(".submit-row").slideDown();
		}
	});

	$("#search-query").blur(function() {
		if ($("#search-query").val() == "") {
			$(".nav-row").each(function() {
				$(this).slideDown();
			});

			$(".submit-row").slideUp();
		}
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

	$('.professor_link').bind('ajax:success', function(xhr, data, status) {
		var target = $(this).data('update-target');
		alert(target);
		$('#' + target).html(data);
		$('#' + target).toggle();
	});

	$('#search-query').autocomplete({
		source: function(request, response) {
			$.ajax({
				url: '/search/search_subdepartment',
				dataType: 'json',
				type: 'GET',
				data: {
					query: request.term
				},
				success: function(data) {
					response($.map(data, function(item) {
						return {
							label: item.mnemonic_number + " " + item.title,
							value: item.mnemonic_number,
							course_id: item.course_id
						}
					}));
				}
			});
		},
		minLength: 2,
		select: function(event, ui) {
			window.location = "/courses/" + ui.item.course_id;
			return false;
		}
	});


	var prof_ajax = $.ajax();

	$("#prof_name").bind("change", function() {
		$("#prof_list").empty();
		var value = $(this).find(":selected").val();
		if (value == "") {
			return;
		}
		prof_ajax.abort();
		prof_ajax = $.ajax({
			url: '/professors/',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$.each(data, function() {
					if (this.last_name[0] == value) {
						$('#prof_list').append($("<a/>", {
							href: "/professors/" + this.id,
							text: this.last_name + ", " + this.first_name
						}));
						$('#prof_list').append($("<br/>", {}));
					}
				});
			}
		});
	});

	jQuery.ajaxSetup({
		beforeSend: function() {
			$('#loading').fadeIn();
			$("#second_letter").show();

		},
		complete: function() {
			$('#loading').hide();
		},
		success: function() {}
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