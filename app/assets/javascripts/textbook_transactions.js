// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {

	var claim_id;

	// Post modal
	$('#post-listing').click(function() {
		$('#post-listing-modal').modal();
	});

	$('#submit-listing').click(function() {
		$.ajax({
			url: '/textbook_transactions',
			method: "POST",
			data: $("#textbook_transaction").serialize(),
			success: function(response) {
				location.reload();
			}
		});
		$('#post-listing-modal').modal('hide');
	});

	// Claim modal
	$('.claim.btn').click(function() {
		claim_id = $(this.id).selector;
		$('#claim-listing-modal').modal();
	});

	$('#submit-claim').click(function() {
		$.ajax({
			url: '/textbook_transactions/claim.' + claim_id,
			method: "POST",
			data: $("#textbook_transaction").serialize(),
			success: function(response) {
				location.reload();
			}
		});
		$('#claim-listing-modal').modal('hide');
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
	// $('#book-titles').autocomplete({
	// 	source: function(request, response) {
	// 		$.ajax({
	// 			url: '/textbook_transactions/search_book_titles',
	// 			dataType: 'json',
	// 			type: 'GET',
	// 			data: {
	// 				query: request.term
	// 			},
	// 			success: function(data) {
	// 				response($.map(data[0], function(item) {
	// 					return {
	// 						label: item.title,
	// 						value: item.title,
	// 						course_id: item.course_id
	// 					}
	// 				}));
	// 			}
	// 		});
	// 	},
	// 	minLength: 2
	// });

	$('#book-titles').keyup(function (key) {
		var query = $(this).val().toLowerCase();
		$('#book-list').first().children().css("display", "inline");
		$('#book-list').first().children().filter(function (index) {
			// console.log($(this).text().includes(query));
			return !$(this).text().toLowerCase().includes(query);
		}).css("display", "none");
	});


});