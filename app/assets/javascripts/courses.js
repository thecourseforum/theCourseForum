var ready;

ready = function() {

  function sortProfessors(selector, attrName) {

    return $($(selector).toArray().sort(function(professorA, professorB) {

      // Compare two professors by a given stat
      retVal = compareProfessors(professorA, professorB, attrName);

      // Handle tie
      if (retVal == 0) {
        var otherSortOptions = [".course-rating", ".course-difficulty", ".course-gpa"];

        for (var i = 0; i < otherSortOptions.length; i++) {
          // Get another stat
          if (attrName != otherSortOptions[i]) {

            // Compare by that stat
            retVal = compareProfessors(professorA, professorB, otherSortOptions[i]);

            // stop if found a tie breaker
            if (retVal != 0) {
              break;
            }
            // if three-way tie, return 0
            if (i == 2 && retVal == 0) {
              return 0;
            }
          }
        }
      }

      return retVal;

    }));
  }

  // Compares two professor panel elements by a given stat (id)
  function compareProfessors(professorA, professorB, stat) {
    // Get stat to sort by (rating, difficulty, gpa)
    var aVal = parseFloat($(professorA).find(stat).text()),
      bVal = parseFloat($(professorB).find(stat).text()),
      retVal = bVal - aVal;

    // Handle no stat
    if (isNaN(aVal) && !isNaN(bVal)) {
      return 1;
    } else if (isNaN(bVal) && !isNaN(aVal)) {
      return -1;
    } else if (isNaN(bVal) && isNaN(aVal)) {
      retVal = 0;
    }

    // Sort difficulty ascending
    if (stat == ".course-difficulty") {
      retVal = retVal * -1;
    }

    return retVal;
  }


  // Sort professors by stats
  $('#prof-sort').change(function() {

    // id of stat to sort by    
    var sortString = ".course-" + $(this).find('.active')[0].id,
      // class of which panels are displayed (current semester or all)
      selectorString = $("#all").parent().hasClass("active") ? ".prof-panel.all" : ".prof-panel.current",
      // how many panels there are (to know when to trigger the next animation)
      numPanels = $(selectorString).length,
      slidPanels = 0,
      // sorted list of professors
      profList = sortProfessors($(".prof-panel"), sortString);
    // if the number of panels displayed is small enough to have smooth animations, animate the change
    if (numPanels < 50) {
      // slide up all the panels. then, on complete, add the sorted ones and slide down what is needed.
      $(selectorString).slideUp(350, function() {
        slidPanels++;
        if (slidPanels == numPanels) {
          $(".prof-panel-container").empty();
          $(".prof-panel-container").append(profList);
          $(selectorString).slideDown(350);
        }
      });
    } else {
      // else just pop on the sorted list
      $(".prof-panel-container").empty();
      $(".prof-panel-container").append(profList);
    }
  });


  // If this is not the section page (no grade wheel),
  // then the rest of this code is not needed
  if (!$('.course-grades').length) {
    return
  }

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
    courseId = courseUrl.substring(courseUrl.search('/') + 1);
    // default sort is recent
    sortType = sortType ? sortType : "recent";

    $.ajax('/courses/reviews', {
      method: "GET",
      data: {
        course_id: courseId,
        professor_id: params ? params['p'] : undefined,
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

  $('.courses-review-type-switcher').change(function() {

    // clear out the reviews (but keep the hidden template one)
    reviews = [];
    $('.reviews-box').empty();
    // set the sort type based on the selected value
    var dropdownVal = $(this).val();

    //load and insert the reviews
    loadReviews(dropdownVal);

  });

  $('#save-course-button').click(function() {
    var course_name = $('#course-name').text().replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    course_name = course_name.split(' - ');
    course_name = course_name[0].split(' ');

    if ($('#save-course-button').text().trim() == 'Unsave') {
      $('#save-course-button').text("Save Course");

      $.ajax('/scheduler/unsave_course', {
        method: "POST",
        data: {
          mnemonic: course_name[0],
          course_number: course_name[1]
        },
        success: function(response) {
          // alert('Course saved for scheduler!');
        },
        failure: function(response) {
          console.log('Could not load corresponding course!');
        }
      });
    } else {
      $('#save-course-button').text("Unsave");
      $.ajax('/scheduler/course', {
        method: "POST",
        data: {
          mnemonic: course_name[0],
          course_number: course_name[1]
        },
        success: function(response) {
          // alert('Course saved for scheduler!');
        },
        failure: function(response) {
          console.log('Could not load corresponding course!');
        }
      });
    }

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

  var professorFilter = "";
  $(document).keydown(function(e) {
    if ($('#professors-switcher').hasClass('open')) {
      if (e.keyCode == 13) {
        $($('#professors-switcher').children('ul').children('li:not(.hidden)')[0]).children('a')[0].click();
      } else {
        $.each($('#professors-switcher').children('ul').children('li'), function(idx, li) {
          $(li).removeClass('hidden');
        });
        if (e.keyCode == 27) {
          professorFilter = "";
        } else if (e.keyCode == 8) {
          e.preventDefault();
          professorFilter = professorFilter.substring(0, professorFilter.length - 1);
        } else {
          professorFilter += String.fromCharCode(e.keyCode).toLowerCase();
        }
        $.each($('#professors-switcher').children('ul').children('li'), function(idx, li) {
          var label = $(li).text().trim().toLowerCase();
          if (label.indexOf(professorFilter) != 0) {
            $(li).addClass('hidden');
          }
        });
      }
    }
  });

  $('#professors-switcher').on('hide.bs.dropdown', function() {
    professorFilter = "";
    $.each($('#professors-switcher').children('ul').children('li'), function(idx, li) {
      $(li).removeClass('hidden');
    });
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

  loadReviews($('.courses-review-type-switcher').val());
}

$(document).ready(ready);

$(document).on('page:load', ready);
