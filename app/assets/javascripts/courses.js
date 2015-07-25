var ready;

ready = function() {

	$('#main-container').scroll(function() {
		if ($('#main-container').prop('scrollHeight') - $('#main-container').scrollTop() <= $('#main-container').height() + 100) {
			if (enableInfiniteScroll) {
				appendReviews();
			}
		}
	});

	var params, search, amount, enableInfiniteScroll = false;
	var reviews;

	// load 10 reviews at a time
	amount = 10;

	if (window.location.search != '') {
		search = window.location.search.substring(1);
		params = JSON.parse('{"' + search.replace(/=/g, '":"').replace(/&/g, '","') + '"}');
		if (params['p']) {
			$('#check-' + params['p']).prop('checked', true);
		}
	}

	function loadReviews(sortType) {
		// get the params
		var courseUrl = window.location.pathname.substring(1);
		courseId = courseUrl.substring(courseUrl.search('/') + 1);
		// default sort is recent
		sortType = sortType ? sortType : "recent";

		$.ajax('/courses/reviews.json', {
			method: "GET",
			data: {
				course_id: courseId,
				professor_id: params ? params['p'] : undefined,
				sort_type: sortType,
			},
			success: function(response) {
				if (response.length > 1) {
					reviews = response
					appendReviews();
					enableInfiniteScroll = true;
				} else {
					enableInfiniteScroll = false;
				}
			}
		});

	}


	function appendReviews() {
		// splice out the reviews to display
		reviewsToAppend = reviews.splice(0, amount);
		// display them
		reviewsToAppend.forEach(function(review) {

			var reviewBox = $('.single-review.hidden').clone().removeClass('hidden');

			// set upvote id and onclick function
			reviewBox.find('.upvote').attr("id", "vote_up_" + review.id)
			reviewBox.find('.upvote').click(voteUp);
			// same for downvote
			reviewBox.find('.downvote').attr("id", "vote_down_" + review.id)
			reviewBox.find('.downvote').click(voteDown);
			// set net votes
			reviewBox.find('.upvotes').attr("id", "votes_" + review.id)
			reviewBox.find('.upvotes').text(review.net_votes);
			// set review comment
			reviewBox.find('.comment').text(review.comment);

			//conditionally apply the active class to the vote buttons (based on vote attr)
			if (review.vote_direction == "up")
				reviewBox.find('.upvote').addClass('active');
			else if (review.vote_direction == "down")
				reviewBox.find('.downvote').addClass('active');
			else {
				reviewBox.find('.upvote').removeClass('active');
				reviewBox.find('.downvote').removeClass('active');
			}

			// set date taken and ratings						
			reviewBox.find('.review-overall').text(review.overall);
			reviewBox.find('.prof').text(parseInt(review.professor_rating));
			reviewBox.find('.enjoyability').text(review.enjoyability);
			reviewBox.find('.difficulty').text(review.difficulty);
			reviewBox.find('.recommend').text(review.recommend);
			if (review.created_at) {
				reviewBox.find('.created').text(review.created_at);
			}
			if (review.taken) {
				reviewBox.find('.taken').text(review.taken);
			}

			if (review.is_author)
				reviewBox.find('.review-author').text("You wrote this!");

			console.log('appended');
			$('.reviews-box').append(reviewBox);

		});
	}

	$('.courses-review-type-switcher').change(function() {

		// clear out the reviews (but keep the hidden template one)
		reviews = [];
		template = $('.single-review.hidden');
		$('.reviews-box').empty().append(template)

		// set the sort type based on the selected value
		var dropdownVal = $(this).val();

		//load and insert the reviews
		enableInfiniteScroll = true;
		loadReviews(dropdownVal);

	});

	$('#save-course').click(function() {
		var course_name = $('#course-name').text().replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		course_name = course_name.split(' - ');
		course_name = course_name[0].split(' ');

		$.ajax('/scheduler/course', {
			method: "POST",
			data: {
				mnemonic: course_name[0],
				course_number: course_name[1]
			},
			success: function(response) {
				alert('Course saved for scheduler!');
			},
			failure: function(response) {
				alert('Could not load corresponding course!');
			}
		});
	});


	$('.skillbar').each(function() {
		$(this).find('.skillbar-bar').animate({
			width: $(this).attr('data-percent')
		}, 1000);
	});

	try {
		$('.carousel').slick({
			infinite: true,
			slidesToShow: 2,
			slidesToScroll: 2,
			dots: true,
			responsive: [{
					breakpoint: 1120,
					settings: {
						slidesToShow: 1,
						slidesToScroll: 1,
						infinite: true,
						dots: true
					}
				},
				// {
				//   breakpoint: 00,
				//   settings: {
				//     slidesToShow: 1,
				//     slidesToScroll: 1
				//   }
				// },
			],
		});
	} catch (error) {
		console.log(error);
	}

	$("#courses-sidebar").css("height", $("#courses-main").height());

	voteUp = function() {
		var review_id = this.id.match(/\d+/)[0];

		if ($("#vote_up_" + review_id).css("opacity") == 1) {
			$.ajax({
				url: '/unvote/' + review_id,
				type: 'POST',
				success: function() {
					$("#vote_up_" + review_id).css("opacity", "0.4");
					var count = $("#votes_" + review_id).text().trim();
					count = parseInt(count) - 1;
					$("#votes_" + review_id).text(count);
				}
			});
		} else {
			$.ajax({
				url: '/vote_up/' + review_id,
				type: 'POST',
				success: function() {
					var wasDownvoted = $("#vote_down_" + review_id).css("opacity") == 1;

					$("#vote_up_" + review_id).css("opacity", "1");
					$("#vote_down_" + review_id).css("opacity", "0.4");

					var count = $("#votes_" + review_id).text().trim();
					if (count == "") {
						count = 1
					} else if (wasDownvoted) {
						count = parseInt(count) + 2;
					} else {
						count = parseInt(count) + 1;
					}

					$("#votes_" + review_id).text(count);


				}
			});
		}
	}

	voteDown = function() {
		var review_id = this.id.match(/\d+/)[0];

		if ($("#vote_down_" + review_id).css("opacity") == 1) {
			$.ajax({
				url: '/unvote/' + review_id,
				type: 'POST',
				success: function() {
					$("#vote_down_" + review_id).css("opacity", "0.4");
					var count = $("#votes_" + review_id).text().trim();
					count = parseInt(count) + 1;
					$("#votes_" + review_id).text(count);
				}
			});
		} else {
			$.ajax({
				url: '/vote_down/' + review_id,
				type: 'POST',
				success: function() {

					var wasUpvoted = $("#vote_up_" + review_id).css("opacity") == 1;

					$("#vote_down_" + review_id).css("opacity", "1");
					$("#vote_up_" + review_id).css("opacity", "0.4");

					var count = $("#votes_" + review_id).text().trim();
					if (count == "") {
						count = -1
					} else if (wasUpvoted) {
						count = parseInt(count) - 2;
					} else {
						count = parseInt(count) - 1;
					}

					$("#votes_" + review_id).text(count);
				}
			});
		}
	}
	loadReviews($('.courses-review-type-switcher').val());
}

$(document).ready(ready);

$(document).on('page:load', ready);