var ready = function() {

	var toggleSpeed = 200;

	var open = false;

	function toggleButton(thisObj) {
		if (!open) {
			thisObj.classList.add('closed');
			open = true;
		} else {
			thisObj.classList.remove('closed');
			open = false;
		}
	};
	// Attatches button to sidebar
	$('.lines-button').click(function() {
		$('aside').toggle('slide', {
			direction: 'left'
		}, toggleSpeed);
		toggleButton(this);
	});

	// this function is used in order to prevent the middle line
	// from 'lagging' behind the color change for the top and bottom
	// buttons

	$('.lines-button').hover(function() {
		$('.lines')[0].classList.add('notransition')
		$('.lines-button').click(function() {
			$('.lines')[0].classList.remove('notransition')
		});
	}, function() {
		$('.lines')[0].classList.remove('notransition')
	});


	// expands user-account options in sidebar on click
	$("a#user-account").click(function() {
		$(".col-secondary").toggle(toggleSpeed);
	});

	$(document).mousedown(function(e) {
		// if click outside of sidebar, and window length is less than 850px, retract sidebar.
		if (!$("aside").is(e.target) && $("aside").has(e.target).length === 0 && $(window).width() < 850 && !$(".lines-button").is(e.target) && $(".lines-button").has(e.target).length === 0) {
			$("aside").hide('slide', toggleSpeed);
			if (open) {
				toggleButton($('.lines-button')[0]);
			}
		}
	});

	// retracts sidebar if esc key is pressed
	$(document).keydown(function(e) {
		if (e.which === 27 && $(window).width() < 850) {
			$("aside").hide('slide', toggleSpeed);
			if (open) {
				toggleButton($('.lines-button')[0]);
			}
		}
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

	$('.professor_link').bind('ajax:success', function(xhr, data, status) {
		var target = $(this).data('update-target');
		alert(target);
		$('#' + target).html(data);
		$('#' + target).toggle();
	});

	$('#search-query').autocomplete({
		source: function(request, response) {
			$.ajax({
				url: '/scheduler/search',
				dataType: 'json',
				type: 'GET',
				data: {
					query: request.term,
					type: 'all'
				},
				success: function(data) {
					response($.map(data.results, function(item) {
						return {
							label: item.label,
							course_id: item.course_id
						}
					}));
				}
			});
		},
		minLength: 2,
		select: function(event, ui) {
			window.location = "/courses/" + ui.item.course_id + '/professors';
			return false;
		}
	});
}
$(document).ready(ready);
$(document).on('page:load', ready);