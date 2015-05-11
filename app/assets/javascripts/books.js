$(document).ready(function() {
	$('#course-mnemonics').keyup(function(key) {
		var courses = $(this).val().split(/,\s?/),
			valid = true;
		$.each(courses, function(index, element) {
			if (!/^\w{2,4}\s?[1-9]\d{3}$/.test(element)) {
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
							bookstoreUsed = row.children('#bookstore-used-price'),
							bookstoreNew = row.children('#bookstore-new-price'),
							amazonOfficial = row.children('#amazon-official-new-price'),
							amazonMerchantUsed = row.children('#amazon-merchant-used-price'),
							amazonMerchantNew = row.children('#amazon-merchant-new-price');

						row.children('#course').text(book.course);
						row.children('#title').text(book.title);
						row.children('#author').text(book.author);
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

						row.click(function() {
							if (book.amazon_affiliate_link) {
								window.open(book.amazon_affiliate_link, '_blank');
							} else {
								alert('No Amazon page for this book!');
							}
						})

						table.append(row);
					});

				}
			});
		}
	});
});