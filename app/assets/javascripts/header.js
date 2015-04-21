var ready = function() {

	$('#report-bug').click(function() {
		$('#report-bug-modal').modal();
		$('input[name="url"]').val(window.location);
	});

	$('#report').click(function() {
		$.ajax('/bugs', {
			method: "POST",
			data: $('#bug').serialize(),
			success: function(response) {
				alert("Thanks for your feedback!");
			}
		});
		$('#report-bug-modal').modal('hide');
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);

var ready = function() {

	$('#better-contact').click(function() {
		$('#contact-us-new-modal').modal();
		$('input[name="url"]').val(window.location);
	});

	$('#report').click(function() {
		$.ajax('/bugs', {
			method: "POST",
			data: $('#bug').serialize(),
			success: function(response) {
				alert("Thanks for your feedback!");
			}
		});
		$('#contact-us-new-modal').modal('hide');
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);