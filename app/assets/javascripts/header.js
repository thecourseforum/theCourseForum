var ready = function() {
		
	$('div').click(function(){
		console.log(this.className);
	});
	$('#report-bug').click(function() {
		$('#report-bug-modal').modal();
		$('input[name="url"]').val(window.location);
	});

	$('#report').click(function() {
		$.ajax('/bugs', {
			method: "POST",
			data: $('#bug').serialize(),
			success: function(nresponse) {
				$('textarea[name="description"]').val('');
				alert("Thanks for your feedback!");
			}
		});
		$('#report-bug-modal').modal('hide');
	});
	var open = false;
	$('.lines-button').click(function(){
		if (!open){
			this.classList.add('closed');
			open = true;
		}
		else {
			this.classList.remove('closed');
			open = false;
		}
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);