var ready = function() {

	var listingsData = [],
		booksData = [],
		listingsToShow,
		listingList,
		booksToShow,
		bookList,
		default_book_cover = '/assets/icons/no_book.png';

	// MyListings page, actions (remove, renew, report)
	$('#my-listing-table').ready(function() {
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
	});

	// Infinite Scroll
	$('#main-container').scroll(function() {
		if ($('#main-container').prop('scrollHeight') - $('#main-container').scrollTop() <= $('#main-container').height() + 100) {
			$('#book-titles').ready(function() {
				window.setTimeout(appendBooks, 500);
			});
			$('#listing-titles').ready(function() {
				window.setTimeout(appendListings, 500);
			});
		}
	});

	// Load textbook data
	$('#post-listing').ready(function() {
		$.ajax({
			url: '/textbooks',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				// data is an array of objects
				// Each object has the attributes: id, title, medium_image_link, mnemonic_numbers, follower_count
				booksData = data;
				$('#book-titles').ready(function() {
					displayBooks(booksData);
				});
			}
		});
	});

	// Load listings data
	$('#listing-titles').ready(function() {
		$.ajax({
			url: '/textbook_transactions/listings',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$('#listing-titles').removeAttr('disabled');
				$('#listing-titles').attr('placeholder', 'e.g. ECON 2010 or Fatal Equilibrium');
				listingsData = data;
				displayListings(listingsData);

				// Somehow not putting it in here will trigger book images not loading.. don't know why
				setTimeout(function() {
					if (window.location.search.indexOf("mnemonic=") != -1) {
						$('#listing-titles').val(decodeURIComponent(window.location.search.split('=')[1]));
						$('#listing-titles').keyup();
					}
				}, 0);
			}
		});
	});

	// Book show page - Load relevant listings data
	$('#follow').ready(function() {
		var id = $('#book-id').text().trim();

		$.ajax({
			url: '/textbook_transactions/listings' + "?book_id=" + id,
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				listingsData = data;
			}
		});
	});

	$('#follow').click(function() {
		var book_id = $(this).attr('data');
		$.ajax({
			url: '/books/follow',
			dataType: 'json',
			type: 'POST',
			data: {
				book_id: book_id
			},
			success: function(data) {
				if (data.status == "unfollowed") {
					$('#followers p').text(parseInt($('#followers p').text()) - 1);
					$('#follow').text('Follow');
				} else {
					$('#followers p').text(parseInt($('#followers p').text()) + 1);
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

		$('#post-thumb').css('height', 'auto');
		$('#post-thumb').css('width', 'auto');

		$('#post-thumb').attr('src', $('#small-image-link').text());
		$('#post-choose').attr('book_id', $('#book-id').text().trim());
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
				error: function(data) {
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
		if (book_id) {} else {
			flagInvalidInput($('#post-choose'));
			isValid = false;
		}
		// Check cell phone
		if (cell) {} else {
			flagInvalidInput($('#cell-input-field'));
			isValid = false;
		}
		// Check price
		if (price) {} else {
			flagInvalidInput($('#price-input-field'));
			isValid = false;
		}
		// Check condition
		if (condition) {} else {
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

	// Claim modal
	$(document).on('click', '.claim', function(event) {
		var claim_id = $(this).attr('id'),
			listing = findListing(claim_id);

		// Prevent multiple firings
		event.stopImmediatePropagation();

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
			if (!validateCell($('#claim-listing-modal [name=cellphone]').val())) {
				flagInvalidInput($('#claim-listing-modal [name=cellphone]'));
				return;
			}
			$(this).off('click');
			$.ajax({
				url: '/textbook_transactions/claim',
				method: "POST",
				data: $("#claim_textbook_transaction").serialize() + "&claim_id=" + claim_id,
				success: function(data) {
					location.reload();
				},
				error: function(data) {
					alert('Error: ' + JSON.parse(data.responseText).message);
				}
			});
			$('#claim-listing-modal').modal('hide');
		});
	});

	function findListing(id) {
		return listingsData.filter(function(item) {
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
		focus: function(event, ui) {
			$('#post-thumb').css('height', 'auto');
			$('#post-thumb').css('width', 'auto');
			$('#post-thumb').attr('src', ui.item.image);
			$('#post-choose').attr('book_id', ui.item.book_id);
			$('#post-choose').text(ui.item.label);
		},
		select: function(event, ui) {
			$('#post-thumb').css('height', 'auto');
			$('#post-thumb').css('width', 'auto');
			$('#post-thumb').attr('src', ui.item.image);
			$('#post-choose').attr('book_id', ui.item.book_id);
			$('#post-choose').text(ui.item.label);
		}
	});

	function filterBookData(dataArray, query) {
		return dataArray.filter(function(item) {
			return item.title.toLowerCase().includes(query.toLowerCase()) || item.mnemonic_numbers.toLowerCase().includes(query.toLowerCase());
		}).sort(function(a, b) {
			return a.title.length - b.title.length;
		});
	}

	function filterListingData(dataArray, query) {
		return dataArray.filter(function(item) {
			return item.title.toLowerCase().includes(query.toLowerCase()) || item.courses.toLowerCase().includes(query.toLowerCase());
		}).sort(function(a, b) {
			return a.title.length - b.title.length;
		});
	}

	// Search Listings
	$('#listing-titles').keyup(function(key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			displayListings(listingsData);
		} else {
			displayListings(filterListingData(listingsData, query));
		}
	});

	function displayListings(listings) {
		var emptyListing = $('.a-listing.hidden');

		listingList = $('#listing-list');
		offset = 0;
		listingsToShow = listings;
		listingList.empty();

		listingList.append(emptyListing);

		appendListings();

	}

	function appendListings() {
		if (listingsToShow && listingsToShow.length >= offset) {
			$.each(listingsToShow.slice(offset, offset + 18), function(index, listing) {
				var line = $('.a-listing.hidden').clone().removeClass('hidden'),
					claim = line.find('.claim'),
					price = line.find('.price'),
					title = line.find('.title a'),
					author = line.find('.author'),
					condition = line.find('.condition'),
					end_date = line.find('.end_date');

				claim.attr('id', listing.id);
				claim.attr('book_image', listing.book_image);

				price.text(listing.price);

				title.text(listing.title);
				title.attr('href', listing.link);

				author.text(listing.author);
				condition.text(listing.condition);
				end_date.text(listing.end_date);

				line.attr('title', "Used in : " + listing.courses + "\nNotes: " + listing.notes);

				listingList.append(line);
			});
			offset += 18;
			return true;
		} else {
			return false;
		}
	}


	// Search Textbooks
	$('#book-titles').keyup(function(key) {
		var query = $(this).val().toLowerCase();
		if (query == '') {
			displayBooks(booksData);
		} else {
			displayBooks(filterBookData(booksData, query));
		}
	});

	$('#post-choose').click(function() {
		drawFocusToBookSearch();
	});

	$('#post-thumb').click(function() {
		drawFocusToBookSearch();
	});

	function drawFocusToBookSearch() {
		$('#book-input-field').focus();
		flagInvalidInput($('#book-input-field'));
	}

	function displayBooks(books) {
		var emptyBook = $('.link-block.hidden');

		bookList = $('#book-list');
		offset = 0;
		booksToShow = books;
		bookList.empty();

		bookList.append(emptyBook);

		appendBooks();
	}

	function appendBooks() {
		if (booksToShow && booksToShow.length >= offset) {
			$.each(booksToShow.slice(offset, offset + 24), function(index, book) {
				var link = $('.link-block.hidden').clone().removeClass('hidden'),
					block = link.find('.a-book'),
					img = block.find('#cover-thumb'),
					title = block.find('#title-thumb'),
					courses_text = book.mnemonic_numbers != '' ? 'Used in ' + book.mnemonic_numbers + "\n" : '';

				link.attr('href', '/books/' + book.id);
				link.attr('title',
					courses_text +
					"Followers: " + book.follower_count
				);

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
}

$(document).ready(ready);
$(document).on('page:load', ready);