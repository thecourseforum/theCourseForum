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

	// Modal autocomplete
	$('#book-title-post').autocomplete({
		source: function(request, response) {
			$.ajax({
				url: '/textbook_transactions/search_book_titles',
				dataType: 'json',
				type: 'GET',
				data: {
					query: request.term
				},
				success: function(data) {
					response($.map(data[0], function(item) {
						return {
							label: item.title,
							value: item.title,
							course_id: item.course_id
						}
					}));
				}
			});
		},
		minLength: 2
	});

	// Search bar autocomplete
	$('#book-titles').autocomplete({
		source: function(request, response) {
			$.ajax({
				url: '/textbook_transactions/search_book_titles',
				dataType: 'json',
				type: 'GET',
				data: {
					query: request.term
				},
				success: function(data) {
					response($.map(data[0], function(item) {
						return {
							label: item.title,
							value: item.title,
							course_id: item.course_id
						}
					}));
				}
			});
		},
		minLength: 2
	});




}