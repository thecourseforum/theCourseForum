// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {

	var claim_id,
		booksData = [],
		booksToShow,
		bookList;

	$.each($('.book-info'), function () {
		booksData.push({
			id: $(this).attr('id'),
			title: $(this).attr('title'),
			image: $(this).attr('image')
		})
		$(this).remove();
	});

	display(booksData);

	$('#follow').click(function () {
		var book_id = $(this).attr('data');
		$.ajax({
			url: '/books/follow',
			dataType: 'json',
			type: 'POST',
			data: {
				book_id: book_id
			},
			success: function (data) {
				console.log($('#follow').text());
				if (data.status == "unfollowed") {
					$('#follow').text('Follow');
				} else {
					$('#follow').text('Unfollow');
				}
			}
		});
	});

	// Post modal
	$('#post-listing').click(function() {
		$('#post-listing-modal').modal();
	});

	$('#sell-yours').click(function() {
		$('#post-listing-modal').modal();
		$('#book-title-post').val($('#book-title').text().trim());
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

	$('#more-books').click(function () {
		if (!appendBooks()) {
			$(this).hide();
		} 
	})

	$('#book-titles').keyup(function (key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			display(booksData);
		} else {
			display(
				booksData.filter(function (book) {
					return book.title.toLowerCase().includes(query);
				}).sort( function (a, b) {
					return a.title.length - b.title.length;
				})
			);
		}
	});

	function display (books) {
		var emptyBook = $('.a-book.hidden');
		
		bookList = $('#book-list');
		offset = 18;
		booksToShow = books;
		bookList.empty();

		bookList.append(emptyBook);

		$.each(booksToShow.slice(0, 18), function (index, book) {
			var block = $('.a-book.hidden').clone().removeClass('hidden'),
				img = block.find('#cover-thumb'),
				title = block.find('#title-thumb');

			img.attr('src', book.image);
			title.text(book.title);
			title.attr('href', '/books/' + book.id);

			bookList.append(block);
		});

		if (booksToShow.length <= 18) {
			$('#more-books').hide();
		} else {	
			$('#more-books').show();
		}
	}

	function appendBooks () {
		if (booksToShow.length >= offset) {
			$.each(booksToShow.slice(offset, offset+12), function (index, book) {
				var block = $('.a-book.hidden').clone().removeClass('hidden'),
					img = block.find('#cover-thumb'),
					title = block.find('#title-thumb');

				img.attr('src', book.image);
				title.text(book.title);
				title.attr('href', '/books/' + book.id);

				bookList.append(block);
			});
			offset += 12;
			return true;
		} else {
			return false;
		}
	}



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
});