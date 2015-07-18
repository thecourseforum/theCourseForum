$(document).ready(function() {

	$('#course-mnemonics').autocomplete({
		source: function(request, response) {
			if (request.term.split(',').pop().trim().length > 1) {
				$.ajax({
					url: '/books/search_subdepartment',
					dataType: 'json',
					type: 'GET',
					data: {
						query: request.term
					},
					success: function(data) {
						response($.map(data[1], function(item) {
							return {
								label: item.mnemonic_number + " " + item.title,
								value: data[0] + item.mnemonic_number,
								course_id: item.course_id
							}
						}));
					}
				});
			}
		},
		minLength: 2
	});

	$('#course-mnemonics').keyup(function(key) {
		var courses = $(this).val().split(/,\s?/),
			valid = true;
		$.each(courses, function(index, element) {
			if (!/^[A-z]{2,4}\s?[1-9]\d{3}$/.test(element)) {
				valid = false;
				return false;
			}
		});

		$('#mnemonics-form').removeClass('has-success');
		$('#mnemonics-form').removeClass('has-error');
		$('#glyph').removeClass('glyphicon-ok');
		$('#glyph').removeClass('glyphicon-remove');

		$('#glyph').addClass('glyphicon-' + (valid ? 'ok' : 'remove'));
		$('#mnemonics-form').addClass('has-' + (valid ? 'success' : 'error'));

		if (key.keyCode == 13 && valid) {
			$.ajax('books/courses', {
				data: {
					mnemonics: JSON.stringify(courses)
				},
				success: function(response) {
					var table = $('#books'),
						emptyRow = $('.book.hidden')

					table.empty();

					table.append(emptyRow);

					if (response.length == 0) {
						table.append("<tr><td>No books found!</td></tr>");
					}

					$.each(response, function(index, book) {
						var row = $('.book.hidden').clone().removeClass('hidden'),
							minimumPrice = 9999,
							maximumPrice = 0,
							minimumDiv = null,
							maximumDiv = null,
							course = row.children('#course'),
							title = row.children('#title'),
							author = row.children('#author'),
							bookstoreUsed = row.children('#bookstore-used-price'),
							bookstoreNew = row.children('#bookstore-new-price'),
							amazonOfficial = row.children('#amazon-official-new-price'),
							amazonMerchantUsed = row.children('#amazon-merchant-used-price'),
							amazonMerchantNew = row.children('#amazon-merchant-new-price');

						course.text(book.course);
						title.text(book.title);
						author.text(book.author);

						bookstoreUsed.text(book.bookstore_used_price ? "$" + book.bookstore_used_price.toFixed(2) : "N/A");
						bookstoreNew.text(book.bookstore_new_price ? "$" + book.bookstore_new_price.toFixed(2) : "N/A");
						amazonOfficial.text(book.amazon_official_new_price ? "$" + book.amazon_official_new_price.toFixed(2) : "N/A");
						amazonMerchantUsed.text(book.amazon_merchant_used_price ? "$" + book.amazon_merchant_used_price.toFixed(2) : "N/A");
						amazonMerchantNew.text(book.amazon_merchant_new_price ? "$" + book.amazon_merchant_new_price.toFixed(2) : "N/A");

						$.each([bookstoreUsed, bookstoreNew, amazonOfficial, amazonMerchantUsed, amazonMerchantNew], function(index, element) {
							price = book[element.attr('id').replace(/-/g, '_')];
							if (price) {
								if (price < minimumPrice) {
									minimumPrice = price;
									minimumDiv = element;
								}
								if (price > maximumPrice) {
									maximumPrice = price;
									maximumDiv = element;
								}
							}
						});

						minimumDiv.removeClass('warning').addClass('success');
						maximumDiv.removeClass('warning').addClass('danger');

						var amazonFunction = function() {
							if (book.amazon_affiliate_link) {
								window.open(book.amazon_affiliate_link, '_blank');
							}
						}

						bookstoreNew.click(function() {
							if (book.bookstore_new_price) {
								window.open('http://uvabookstores.com/uvatext/default.asp', '_blank');
							}
						});

						bookstoreUsed.click(function() {
							if (book.bookstore_used_price) {
								window.open('http://uvabookstores.com/uvatext/default.asp', '_blank');
							}
						});

						course.click(function() {
							window.open("/courses/" + book.course_id, '_blank');
						});
						title.click(amazonFunction);
						author.click(amazonFunction);
						amazonOfficial.click(amazonFunction);
						amazonMerchantNew.click(amazonFunction);
						amazonMerchantUsed.click(amazonFunction);

						if (book.large_image_link) {
							row.popover({
								content: "<img class='img-thumbnail' src='" + book.large_image_link + "'/>",
								html: true,
								placement: 'left',
								trigger: 'hover',
								container: 'body'
							});
						}

						table.append(row);
					});

				}
			});
		}
	});
});