$(document).ready(function() {

	var searchResults = {};

	$('#class-search').keyup(function(key) {
		// Anonymous function gets passed in the keyCode of the pressed key, 13 is the Enter key
		if (key.keyCode == 13) {
			// Call internal function courseSearch with the search phrase passed in by the textbox
			courseSearch($(this).val());
		}
	});

	$('#class-search').focus(function() {
		$('#saved-courses').slideUp();
		$('#clear-courses').slideUp();
	});

	$('#class-search').blur(function() {
		$('#search-classes').removeClass('loading');
		$('#saved-courses').slideDown();
		$('#clear-courses').slideDown();
	});

	$('#class-search').autocomplete({
		source: function(request, response) {
			$.ajax('/scheduler/search', {
				data: {
					term: request.term
				},
				success: function(data) {
					response(data.results);
				}
			});
		},
		open: function() {
			$('.ui-autocomplete').css('width', ($('#class-search').parent().width()));
		},
		select: function(event, ui) {
			courseSearch(ui.item.value);
		}
	});

	// Added search button functionality
	$('#search-classes').click(function() {
		courseSearch($('#class-search').val());
	});

	// Alternatively, users can also "search" by selecting a prior saved course
	// Attaches an anonymous function to the change event thrown by the saved-courses combobox
	$('#saved-courses').change(function() {
		// For the selected option, trim any whitespace or newline around its text
		var course = $.trim($('#saved-courses option:selected').text());
		// Ignore the placeholder option at the very top
		if (course !== '-- Select Course --') {
			// Call internal function courseSearch with the search phrase associated with the selected option
			courseSearch(course);
		}
	});

	// Asks server for course information + sections based on search string
	function courseSearch(course) {
		// If text was empty, implies that user wants to clear all courses
		if (course === '') {
			// Updates internal representation, searchResults
			searchResults = {};
			// Clears HTML view
			resultBox.empty();
		} else {
			// Split the course search string (i.e. CS 2150) into two portions, mnemonic and course_number
			course = course.split(' ');
			// If the user enters search string w/o a space, it accomodates for it.
			if (course.length == 1) {
				course = course[0].match(/([A-Za-z]+)([0-9]+)/);
				course = new Array(course[1], course[2]);
			}
			$('#search-classes').addClass('loading');
			$.ajax('books/course', {
				// mnemonic - "CS"
				// course_number - "2150"
				data: {
					mnemonic: course[0],
					course_number: course[1]
				},
				success: function(response) {
					// Returned course object must have id (response.id is course.id)
					if (!searchResults[response.id]) {
						// Initialize this course in searchResults
						// See above for sample searchResults representation
						searchResults[response.id] = response.books;
						// Calls utility function for showing the course (HTML)
						displayResult(response);
					}
				},
				error: function(response) {
					alert("Improper search!");
				},
				complete: function() {
					$('#search-classes').removeClass('loading');
				}
			});
		}
	}

	function displayResult(result) {
		var resultBox = $('.course-result.hidden').clone().removeClass('hidden'),
			content = resultBox.children('#content'),
			checkbox = resultBox.children('#checkbox').children(':checkbox');

		content.children('.remove').text('x');
		content.children('.remove').css({
			"float": "right",
			"color": "white"
		});

		content.children('.remove').click(function() {
			delete searchResults[result.id];
			$(this).parent().parent().remove();
		});

		content.children('.course-mnemonic').text(result.course_mnemonic);
		content.children('.course-title').text(result.title);

		showBooks(result.books);

		$('#results-box').append(resultBox);
	}

	function showBooks(books) {
		for (var i = 0; i < books.length; i++) {
			book = books[i];

			var bookRow = $('.row.hidden').clone().removeClass('hidden'),
				title = bookRow.find('#title'),
				// author = bookRow.find('#author'),
				bookstore = bookRow.find('#bookstore'),
				amazonOfficial = bookRow.find('#amazon-official'),
				amazonMerchant = bookRow.find('#amazon-merchant');

			title.text(book.title);
			title.attr('href', book.amazon_affiliate_link);
			// author.text(book.author);
			// author.attr('href', book.amazon_affiliate_link);

			$('#books').append(bookRow);
		}
	}
});