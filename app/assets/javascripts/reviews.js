var ready;

ready = function() {
	$('.myreview-container').parent().css({
		'box-shadow': 'none',
		'background-color': '#eee',
  		'padding-top': '0px',
  		'padding-left': '0px',
  		'padding-right': '0px',
	});

	if ($("#new_review").length > 0 || $(".edit_review").length > 0) {
		$("#review-button").on("click", function() {
			if (!$("#prof_select").val()) {
				alert("Please select a course to review.");
				return false;
			} else if (!$("#semester_season").val()) {
				alert("Please enter the season you took the course.");
				return false;
			} else if (!$("#semester_year").val()) {
				alert("Please enter the year you took the course.");
				return false;
			} else if (!$('#review_professor_rating').val()) {
				alert("Please give a Professor Rating.");
				return false;
			} else if (!$('#review_enjoyability').val()) {
				alert("Please give a Fun Factor rating.");
				return false;
			} else if (!$('#review_difficulty').val()) {
				alert("Please give a Difficulty rating.");
				return false;
			} else if (!$('#review_recommend').val()) {
				alert("Please give a Recommendability rating.");
				return false;
			}
		});

		function course_compare(a, b) {
			var course1 = a.subdepartment.mnemonic + " " + a.course_number
			var course2 = b.subdepartment.mnemonic + " " + b.course_number

			if (course1.toUpperCase() < course2.toUpperCase()) return -1;
			if (course1.toUpperCase() > course2.toUpperCase()) return 1;
			return 0;
		}

		$("#subdept_select").bind("change", function() {
			$("#prof_select").prop("disabled", true);
			$("#course_select").prop("disabled", false);
			$("#course_select").empty();
			$("#prof_select").empty();
			var value = $(this).find(":selected").val();
			$.ajax({
				url: '/subdepartments/' + value,
				dataType: 'json',
				type: 'GET',
				success: function(data) {
					$("#courses").fadeIn("fast");
					data = data.sort(course_compare);
					$.each(data, function() {
						$('#course_select').append($("<option/>", {
							value: this.id,
							text: this.subdepartment.mnemonic + " " + this.course_number
						}));
					});

					course_select.selectedIndex = -1;

				}
			});
		});

		$("#course_select").bind("change", function() {
			$("#prof_select").prop("disabled", false);
			$("#prof_select").empty();
			var value = $(this).find(":selected").val();
			$.ajax({
				url: '/courses/' + value + '.json',
				dataType: 'json',
				type: 'GET',
				success: function(data) {
					$("#professors").fadeIn("fast");
					$.each(data.professors_list, function() {
						$('#prof_select').append($("<option/>", {
							value: this.id,
							text: this.last_name + ", " + this.first_name
						}));
					});
					var prof_select = document.getElementById("prof_select");
					if (prof_select.length > 1) {
						prof_select.selectedIndex = -1;
					}
				}
			});

		});

    $(function() {
      $('#review_professor_rating').barrating({
        theme: 'bars-movie',
        onSelect: function (value, text) {
          $('#review_professor_rating').val(parseInt(value));
        }
      });
    });

    $(function() {
      $('#review_enjoyability').barrating({
        theme: 'bars-movie',
        onSelect: function (value, text) {
          $('#review_enjoyability').val(value);
        }
      });
    });

    $(function() {
      $('#review_difficulty').barrating({
        theme: 'bars-movie',
        onSelect: function (value, text) {
          $('#review_difficulty').val(value);
        }
      });
    });

    $(function() {
      $('#review_recommend').barrating({
        theme: 'bars-movie',
        onSelect: function (value, text) {
          $('#review_recommend').val(value);
        }
      });
    });
  }
}
$(document).ready(ready);
$(document).on('page:load', ready);
