var ready;

ready = function() {

  window.onscroll = function(ev) {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight && $('.reviews-box').children('.hidden').length > 0) {
      $('.wheel-loader').removeClass('hidden');
      setTimeout(function () {
        appendReviews();
        $('.wheel-loader').addClass('hidden');
      }, 800);
    }
  };

  var params, search, amount, lastIndex;
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
    profId = courseUrl.substring(courseUrl.search('/') + 1);
    // default sort is recent
    sortType = sortType ? sortType : "recent";

    $.ajax('/professors/reviews', {
      method: "GET",
      data: {
        professor_id: profId,
        sort_type: sortType,
      },
      success: function(response) {
        $('.reviews-box').append(response);
        $('[id^="vote_up_"]').click(voteUp);
        $('[id^="vote_down_"]').click(voteDown);
        appendReviews();
      }
    });

  }

  function appendReviews() {
    var index = 0;
    $('.reviews-box').children('.hidden').each(function(review) {
      if (index <= amount) {
        index++;
        ($(this).removeClass('hidden'));
      } else {
        return;
      }
    });
  }

  $('.professor-review-type-switcher').change(function() {

    // clear out the reviews (but keep the hidden template one)
    reviews = [];
    $('.reviews-box').empty();
    // set the sort type based on the selected value
    var dropdownVal = $(this).val();

    //load and insert the reviews
    loadReviews(dropdownVal);

  });

  voteUp = function() {
    var review_id = this.id.match(/\d+/)[0];

    if ($("#vote_up_" + review_id).css("opacity") == 1) {
      $.ajax({
        url: '/unvote/' + review_id,
        type: 'POST',
        success: function() {
          $("#vote_up_" + review_id).removeClass("vote-active");
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
          var wasDownvoted = $("#vote_down_" + review_id).hasClass("vote-active");

          $("#vote_up_" + review_id).addClass("vote-active");
          $("#vote_down_" + review_id).removeClass("vote-active");

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
          $("#vote_down_" + review_id).removeClass("vote-active");
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

          var wasUpvoted = $("#vote_up_" + review_id).hasClass("vote-active");
          $("#vote_down_" + review_id).addClass("vote-active");
          $("#vote_up_" + review_id).removeClass("vote-active");

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

  loadReviews($('.professor-review-type-switcher').val());
}

$(document).ready(ready);

$(document).on('page:load', ready);
