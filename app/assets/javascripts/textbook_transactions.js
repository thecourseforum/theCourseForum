// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {

	var claim_id,
		listingsData = [],
		listingsToShow,
		listingList,
		booksData = [],
		booksToShow,
		bookList;

	// Load textbok data
	$.each($('.book-info'), function () {
		booksData.push({
			id: $(this).attr('id'),
			title: $(this).attr('title'),
			image: $(this).attr('image')
		});
		$(this).remove();
	});
	displayBooks(booksData);

	// Load listings data
	$.each($('.listing-info'), function () {
		listingsData.push({
			id: $(this).attr('id'),
			price: $(this).attr('price'),
			courses: $(this).attr('courses'),
			title: $(this).attr('title'),
			link: $(this).attr('link'),
			author: $(this).attr('author'),
			condition: $(this).attr('condition'),
			notes: $(this).attr('notes'),
			end_date: $(this).attr('end_date')
		});
		$(this).remove();
	});
	displayListings(listingsData);

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
			data: $("#post_textbook_transaction").serialize(),
			success: function(data) {
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
			data: $("#claim_textbook_transaction").serialize(),
			success: function(data) {
				if (data.status == "success") {
					location.reload();
				} else {
					alert("Error: Bad phone number.\nEnter 10 digits");
				}
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

	
	// Search Listings
	$('#book-titles-listings').keyup(function (key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			displayListings(listingsData);
		} else {
			displayListings(
				listingsData.filter(function (listing) {
					return listing.title.toLowerCase().includes(query);
				}).sort( function (a, b) {
					// Sort by ascending title length
					return a.title.length - b.title.length;
				})
			);
		}
	});
	$('#more-listings').click(function () {
		if (!appendListings()) {
			$(this).hide();
		} 
	});
	function displayListings (listings) {
		var emptyListing = $('.a-listing.hidden');
		
		listingList = $('#listing-list');
		offset = 0;
		listingsToShow = listings;
		listingList.empty();

		listingList.append(emptyListing);

		appendListings();

		if (listingsToShow.length <= 18) {
			$('#more-listings').hide();
		} else {	
			$('#more-listings').show();
		}
	}
	function appendListings () {
		if (listingsToShow.length >= offset) {
			$.each(listingsToShow.slice(offset, offset+18), function (index, listing) {
				var line = $('.a-listing.hidden').clone().removeClass('hidden'),
					claim = line.find('.claim'),
					price = line.find('.price'),
					courses = line.find('.courses'),
					title = line.find('.title a'),
					author = line.find('.author'),
					condition = line.find('.condition'),
					notes = line.find('.notes'),
					end_date = line.find('.end_date');

				claim.attr('id', listing.id);
				price.text(listing.price);
				courses.text(listing.courses);
				title.attr('href', listing.link);
				title.text(listing.title);
				author.text(listing.author);
				condition.text(listing.condition);
				notes.text(listing.notes);
				end_date.text(listing.end_date);

				listingList.append(line);
			});
			offset += 18;
			return true;
		} else {
			return false;
		}
	}

	
	// Search Textbooks
	$('#book-titles').keyup(function (key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			displayBooks(booksData);
		} else {
			displayBooks(
				booksData.filter(function (book) {
					return book.title.toLowerCase().includes(query);
				}).sort( function (a, b) {
					// Sort by ascending title length
					return a.title.length - b.title.length;
				})
			);
		}
	});
	$('#more-books').click(function () {
		if (!appendBooks()) {
			$(this).hide();
		} 
	});
	function displayBooks (books) {
		var emptyBook = $('.a-book.hidden');
		
		bookList = $('#book-list');
		offset = 0;
		booksToShow = books;
		bookList.empty();

		bookList.append(emptyBook);

		appendBooks();

		if (booksToShow.length <= 18) {
			$('#more-books').hide();
		} else {	
			$('#more-books').show();
		}
	}
	function appendBooks () {
		if (booksToShow.length >= offset) {
			$.each(booksToShow.slice(offset, offset+18), function (index, book) {
				var block = $('.a-book.hidden').clone().removeClass('hidden'),
					img = block.find('#cover-thumb'),
					title = block.find('#title-thumb');

				img.attr('src', book.image);
				title.text(book.title);
				title.attr('href', '/books/' + book.id);

				bookList.append(block);
			});
			offset += 18;
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