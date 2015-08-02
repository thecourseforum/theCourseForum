// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {

	var listingsData = [],
		listingsToShow,
		listingList,
		listingScrollEnabled = false,
		booksData = [],
		booksToShow,
		bookList,
		bookScrollEnabled = false;

	const default_book_cover = '/assets/icons/no_book.png'

	// Infinite Scroll
	$('#main-container').scroll(function() {
		if ($('#main-container').prop('scrollHeight') - $('#main-container').scrollTop() <= $('#main-container').height() + 100) {
			if (bookScrollEnabled) {
				bookScrollEnabled = appendBooks();
			}
			if (listingScrollEnabled) {
				listingScrollEnabled = appendListings();
			}
		}
	});

	// Load textbook data
	if ($('#post-listing').length) {
		$.ajax({
			url: '/textbook_transactions/books',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				// data is an array of arrays
				// ex. data[0] #=> [id, title, small_image_link]
				booksData = data;
				displayBooks(booksData);
			}
		});
		bookScrollEnabled = true;
	}

	// Load listings data
	if ($('#listing-titles').length) {
		$.ajax({
			url: '/textbook_transactions/listings',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				listingsData = data;
				$('#listing-titles').removeAttr('disabled');
				$('#listing-titles').attr('placeholder','Enter a Book Title ex. Little Women');
				displayListings(listingsData);
			}
		});
		listingScrollEnabled = true;
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
		$('#post-choose').attr('book_id', $('#book-link').text());
		$('#post-choose').text($('#book-title').text().trim());
	});
	$('#submit-listing').hover(function() {
		validateListing();
	});
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
					notes: notes
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
		element.css('box-shadow', '0 0 5px #a94442');
		element.css('border', '1px solid #a94442');
	}
	function flagValidInput(element) {
		element.css('box-shadow', '0 0 5px #3c763d');
		element.css('border', '1px solid #3c763d');
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
		
		$('#submit-claim').click(function() {
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

	// Modal autocomplete
	$('#book-input-field').autocomplete({
		source: function(request, response) {
			response($.map(filterData(booksData, request.term), function(book) {
				return {
					book_id: book[0],
					label: book[1],
					value: request.term,
					image: book[2]
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
		}
	});

	function filterData (dataArray, query) {
		return dataArray.filter(function (item) {
			return item[1].toLowerCase().includes(query.toLowerCase());
		}).sort(function (a, b) {
			return a[1].length - b[1].length;
		});
	}
	
	function filterListingData (dataArray, query) {
		return dataArray.filter(function (item) {
			return item.title.toLowerCase().includes(query.toLowerCase());
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

		listingScrollEnabled = true;
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
		if (listingsToShow.length >= offset) {
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
			displayBooks(filterData(booksData, query));
		}

		bookScrollEnabled = true;
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
		if (booksToShow || booksToShow.length >= offset) {
			$.each(booksToShow.slice(offset, offset+24), function (index, book) {
				var link = $('.link-block.hidden').clone().removeClass('hidden'),
					block = link.find('.a-book'),
					img = block.find('#cover-thumb'),
					title = block.find('#title-thumb');

				link.attr('href', '/books/' + book[0]);
				title.text(book[1]);

				book[2] = book[2] ? book[2] : default_book_cover
				img.attr('src', book[2]);

				bookList.append(link);
			});
			offset += 24;
			return true;
		} else {
			return false;
		}
	}

});