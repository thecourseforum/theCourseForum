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
				$('textarea[name="description"]').val('');
				alert("Thanks for your feedback!");
			}
		});
		$('#report-bug-modal').modal('hide');
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);