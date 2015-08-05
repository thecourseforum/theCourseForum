// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {

	var listingsData = [],
		listingsToShow,
		listingList,
		isListingPage = false,
		booksData = [],
		booksToShow,
		bookList,
		isBookPage = false,
		isMyListingPage = false;

	const default_book_cover = '/assets/icons/no_book.png'

	if ($('#listing-titles').length) {
		isListingPage = true;
	}
	if ($('#book-titles').length) {
		isBookPage = true;
	}

	// MyListings page, actions (remove, renew, report)
	if ($('#my-listing-table').length) {
		isMyListingPage = true;
		$(document).on('click', '.action', function() {
			var actionName = $(this).attr('action'),
				listing_id = $(this).attr('id');

			if (actionName == "report") {
				$('#report-bug-modal').modal();
			} else {
				$.ajax({
					url: '/textbook_transactions/' + actionName,
					dataType: 'json',
					type: 'POST',
					data: {
						listing_id: listing_id
					},
					success: function(data) {
						location.reload();
					},
					error: function(data) {
						alert("Something went wrong :(");
					}
				});
			}

		});
	}

	// Infinite Scroll
	$('#main-container').scroll(function() {
		if ($('#main-container').prop('scrollHeight') - $('#main-container').scrollTop() <= $('#main-container').height() + 100) {
			if (isBookPage) {
				window.setTimeout(appendBooks, 500);
			}
			if (isListingPage) {
				window.setTimeout(appendListings, 500);
			}
		}
	});

	// Load textbook data
	if ($('#post-listing').length) {
		$.ajax({
			url: '/textbooks',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				// data is an array of objects
				// Each object has the attributes: id, title, medium_image_link, mnemonic_numbers
				booksData = data;
				if (isBookPage) {
					displayBooks(booksData);
				}
			}
		});
	}

	// Load listings data
	if ($('#listing-titles').length) {
		$.ajax({
			url: '/textbook_transactions/listings',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$('#listing-titles').removeAttr('disabled');
				$('#listing-titles').attr('placeholder','e.g. Little Women or ECON 2010');
				listingsData = data;
				displayListings(listingsData);
			}
		});
	}

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

		$('#search-label').remove();
		$('#book-input-field').remove();

		$('#post-thumb').attr('src', $('#small-image-link').text());
		$('#post-choose').attr('book_id', $('#book-id').text());
		$('#post-choose').text($('#book-title').text().trim());
	});
	$('#book-input-field').change(validateListing);
	$('#price-input-field').change(validateListing);
	$('#condition-input-field').change(validateListing);
	$('#cell-input-field').change(validateListing);
	$('#submit-listing').click(function() {
		var book_id = $('#post-choose').attr('book_id'),
			cell = validateCell($('#cell-input-field').val()),
			price = $('#price-input-field').val().trim(),
			condition = $('#condition-input-field').val(),
			notes = $('#note-input-field').val();

		if (validateListing()) {
			$.ajax({
				url: '/textbook_transactions',
				method: "POST",
				data: {
					book_id: book_id,
					cellphone: cell,
					price: price,
					condition: condition,
					notes: notes.trim()
				},
				success: function(data) {
					location.reload();
				},
				error: function (data) {	
					alert('Error: ' + JSON.parse(data.responseText).message);
				}
			});
			$('#post-listing-modal').modal('hide');
		}

	});
	function validateListing() {
		var book_id = $('#post-choose').attr('book_id'),
			cell = validateCell($('#cell-input-field').val()),
			price = validatePrice($('#price-input-field').val()),
			condition = $('#condition-input-field').val(),
			notes = $('#note-input-field').val(),
			isValid = true;

		// Check if book choosen
		if (book_id) {
			flagValidInput($('#book-input-field'));
		} else {
			flagInvalidInput($('#book-input-field'));
			isValid = false;
		}
		// Check cell phone
		if (cell) {
			flagValidInput($('#cell-input-field'));
		} else {
			flagInvalidInput($('#cell-input-field'));
			isValid = false;
		}
		// Check price
		if (price) {
			flagValidInput($('#price-input-field'));
		} else {
			flagInvalidInput($('#price-input-field'));
			isValid = false;
		}
		// Check condition
		if (condition) {
			flagValidInput($('#condition-input-field'));
		} else {
			flagInvalidInput($('#condition-input-field'));
			isValid = false;
		}
		return isValid;
	}
	function validateCell(input) {
		input = input.replace(/[^0-9]/g, '');
		if (input.length == 10) {
			return input;
		} else {
			return '';
		}
	}
	function validatePrice(input) {
		input = input.replace(/[^0-9]/g, '');
		return input;	
	}
	function flagInvalidInput(element) {
		element.css('-webkit-transition', 'box-shadow 1s ease, border 1s ease');
		element.css('transition', 'box-shadow 1s ease, border 1s ease');

		element.css('box-shadow', '0 0 5px #c26564');
		element.css('border', '1px solid #c26564');

		setTimeout(function() {
			element.css('box-shadow', '');
			element.css('border', '');
		}, 1000);
	}
	function flagValidInput(element) {
		element.css('-webkit-transition', 'box-shadow 1s ease, border 1s ease');
		element.css('transition', 'box-shadow 1s ease, border 1s ease');

		element.css('box-shadow', '0 0 5px #7ebd7f');
		element.css('border', '1px solid #7ebd7f');

		setTimeout(function() {
			element.css('box-shadow', '');
			element.css('border', '');
		}, 1000);
	}
	
	// Claim modal
	$(document).on('click', '.claim', function() {
		var claim_id = $(this).attr('id'),
			listing = findListing(claim_id);

		$('#claim_cover').attr('src', listing.book_image);
		$('#claim_title').text(listing.title);
		$('#claim_author').text(listing.author);
		$('#claim_courses').text(listing.courses);
		$('#claim_condition').text(listing.condition);
		$('#claim_notes').text(listing.notes);
		$('#claim_end_date').text(listing.end_date);
		$('#claim_price').text(listing.price);

		$('#claim-listing-modal').modal();
		
		$('#submit-claim').on('click', function() {
			$(this).off('click');
			$.ajax({
				url: '/textbook_transactions/claim',
				method: "POST",
				data: $("#claim_textbook_transaction").serialize() + "&claim_id=" + claim_id,
				success: function(data) {
					location.reload();
				},
				error: function (data) {	
					alert('Error: ' + JSON.parse(data.responseText).message);
				}
			});
			$('#claim-listing-modal').modal('hide');
		});
	});
	function findListing(id) {
		return listingsData.filter(function (item) {
			return item.id == id;
		})[0];
	}

	// Post Modal autocomplete
	$('#book-input-field').autocomplete({
		source: function(request, response) {
			response($.map(filterBookData(booksData, request.term), function(book) {
				return {
					book_id: book.id,
					label: book.title,
					value: request.term,
					image: book.medium_image_link ? book.medium_image_link : default_book_cover
				}
			}));
		},
		focus: function(event, ui){
			$('#post-thumb').removeAttr('hide');
			$('#post-thumb').attr('src', ui.item.image);
			$('#post-choose').attr('book_id', ui.item.book_id);
			$('#post-choose').text(ui.item.label);
		},
		select: function(event, ui) {
			$('#post-thumb').removeAttr('hide');
			$('#post-thumb').attr('src', ui.item.image);
			$('#post-choose').attr('book_id', ui.item.book_id);
			$('#post-choose').text(ui.item.label);
			$('#book-input-field').value = '';
		}
	});

	function filterBookData (dataArray, query) {
		return dataArray.filter(function (item) {
			return item.title.toLowerCase().includes(query.toLowerCase()) || item.mnemonic_numbers.toLowerCase().includes(query.toLowerCase());
		}).sort(function (a, b) {
			return a.title.length - b.title.length;
		});
	}
	
	function filterListingData (dataArray, query) {
		return dataArray.filter(function (item) {
			return item.title.toLowerCase().includes(query.toLowerCase()) || item.courses.toLowerCase().includes(query.toLowerCase());
		}).sort(function (a, b) {
			return a.title.length - b.title.length;
		});
	}
	
	// Search Listings
	$('#listing-titles').keyup(function (key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			displayListings(listingsData);
		} else {
			displayListings(filterListingData(listingsData, query));
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

	}
	function appendListings () {
		if (listingsToShow && listingsToShow.length >= offset) {
			$.each(listingsToShow.slice(offset, offset+18), function (index, listing) {
				var line = $('.a-listing.hidden').clone().removeClass('hidden'),
					claim = line.find('.claim'),
					price = line.find('.price'),
					courses = line.find('.courses'),
					title = line.find('.title a'),
					author = line.find('.author'),
					condition = line.find('.condition'),
					end_date = line.find('.end_date');

				claim.attr('id', listing.id);
				claim.attr('book_image', listing.book_image);
				price.text(listing.price);
				courses.text(listing.courses);
				title.attr('href', listing.link);
				title.text(listing.title);
				author.text(listing.author);
				condition.text(listing.condition);
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
			displayBooks(filterBookData(booksData, query));
		}
	});
	function displayBooks (books) {
		var emptyBook = $('.link-block.hidden');
		
		bookList = $('#book-list');
		offset = 0;
		booksToShow = books;
		bookList.empty();

		bookList.append(emptyBook);

		appendBooks();
	}
	function appendBooks () {
		if (booksToShow && booksToShow.length >= offset) {
			$.each(booksToShow.slice(offset, offset+24), function (index, book) {
				var link = $('.link-block.hidden').clone().removeClass('hidden'),
					block = link.find('.a-book'),
					img = block.find('#cover-thumb'),
					title = block.find('#title-thumb');

				link.attr('href', '/books/' + book.id);
				link.attr('title', 'Used in ' + book.mnemonic_numbers);
				title.text(book.title);

				book.medium_image_link = book.medium_image_link ? book.medium_image_link : default_book_cover
				img.attr('src', book.medium_image_link);

				bookList.append(link);

			});
			offset += 24;
			return true;
		} else {
			return false;
		}
	}

});