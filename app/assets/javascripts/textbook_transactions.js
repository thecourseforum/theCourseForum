// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
window.onload = function () {
	$('#post-listing').click(function() {
		$('#post-listing-modal').modal();
	});

	$('#submit-listing').click(function() {
		var isSelling = ($("#sell-option").hasClass("active"));
		$.ajax({
			url: '/textbook_transactions',
			method: "POST",
			data: $("#textbook_transaction").serialize() + "&sell?=" + isSelling,
			success: function(response) {
				alert("Listing Posted!");
			}
		});
		$('#post-listing-modal').modal('hide');
	});

	// $('#book-titles').autocomplete({
	// 	source: function(request, response) {

	// 	}
	// });


}