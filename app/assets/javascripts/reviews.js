$(document).ready(function() {
  if ($("#new_review").length > 0 || $(".edit_review").length > 0)
  {
    $("#review-button").on("click", function(){
      if (!$("#prof_select").val()){
        alert("Please select a course to review.");
        return false;
      }
      else if (!$("#semester_season").val())
      {
        alert("Please enter the season you took the course.");
        return false;
      }
      else if (!$("#semester_year").val())
      {
        alert("Please enter the year you took the course.");
        return false;
      }
      else if (!$("input[name=review\\[professor_rating\\]]").is(":checked"))
      {
        alert("Please give a Professor Rating.");
        return false;
      }
      else if (!$("input[name=review\\[recommend\\]]").is(":checked"))
      {
        alert("Please give a Fun Factor rating.");
        return false;
      }
      else if (!$("input[name=review\\[difficulty\\]]").is(":checked"))
      {
        alert("Please give a Difficulty rating.");
        return false;
      }
      else if (!$("input[name=review\\[recommend\\]]").is(":checked"))
      {
        alert("Please give a Recommendability rating.");
        return false;
      }
    });

    function course_compare(a,b)
    {
      var course1 = a.subdepartment.mnemonic + " " + a.course_number
      var course2 = b.subdepartment.mnemonic + " " + b.course_number

      if (course1.toUpperCase() < course2.toUpperCase()) return -1;
      if (course1.toUpperCase() > course2.toUpperCase()) return 1;
      return 0;
    }

    $("#subdept_select").bind("change", function(){
      $("#professors").fadeOut("fast");
      $("#courses").fadeOut("fast");
      $("#course_select").empty();
      var value = $(this).find(":selected").val();
      $.ajax({
        url: '/subdepartments/' + value,
        dataType: 'json',
        type: 'GET',
        success: function(data) {
          $("#courses").fadeIn("fast");
          data = data.sort(course_compare);
          $.each(data, function(){
            $('#course_select').append($("<option/>", {
              value: this.id,
              text: this.subdepartment.mnemonic + " " + this.course_number
            }));
          });     
          
          course_select.selectedIndex = -1;     
          
        }
      });

    });

    $("#course_select").bind("change", function(){
      $("#prof_select").empty();
      var value = $(this).find(":selected").val();
      $.ajax({
        url: '/courses/' + value,
        dataType: 'json',
        type: 'GET',
        success: function(data) {
          $("#professors").fadeIn("fast");
          $.each(data.professors_list, function(){
            $('#prof_select').append($("<option/>", {
              value: this.id,
              text: this.last_name + ", " + this.first_name
            }));
          });     
          var prof_select = document.getElementById("prof_select");
          if(prof_select.length > 1){
            prof_select.selectedIndex = -1;
          }
        }
      });
      
    });

    var prof_radios = $("input[id*=review_professor_rating]");
    var selected_prof = $("input[id*=review_professor_rating]:checked");
    if (selected_prof.length > 0)
    {
      var prof_val = selected_prof.val();
      if (prof_val*10 % 10 == 5)
      {
        $(".current-prof-rating").text(prof_val);
      }
      else
      {
        $(".current-prof-rating").text(parseInt(prof_val));
      }

      if (prof_val < 3)
        $(".current-prof-rating").css("background-color", "#FF1111");
      else if (prof_val < 4.5)
        $(".current-prof-rating").css("background-color", "#FFFF00");
      else
        $(".current-prof-rating").css("background-color", "#00BB00");
    }
    else
    {
      var prof_val = 3;
      prof_radios[2].click();
      $(".current-prof-rating").text(prof_val);
      $(".current-prof-rating").css("background-color", "#FFFF00");
    }  

    $( ".prof-rating-slider" ).slider({
      step: 1,
      min: 2,
      max: 10,
      value: prof_val*2,
      slide: function(event, ui) {
        prof_radios[ui.value-2].click();
        $(".current-prof-rating").text(ui.value/2);
        if (ui.value/2 < 3)
          $(".current-prof-rating").css("background-color", "#FF1111");
        else if (ui.value/2 < 4.5)
          $(".current-prof-rating").css("background-color", "#FFFF00");
        else
          $(".current-prof-rating").css("background-color", "#00BB00");
      }
    });

    var enjoy_radios = $("input[id*=review_enjoyability]");
    var selected_enjoy = $("input[id*=review_enjoyability]:checked");
    if (selected_enjoy.length > 0)
    {

      var enjoy_val = selected_enjoy.val();
      $(".current-enjoyability").text(enjoy_val);

      if (enjoy_val < 3)
        $(".current-enjoyability").css("background-color", "#FF1111");
      else if (enjoy_val < 4.5)
        $(".current-enjoyability").css("background-color", "#FFFF00");
      else
        $(".current-enjoyability").css("background-color", "#00BB00");
    }
    else
    {
      var enjoy_val = 3;
      enjoy_radios[2].click();
      $(".current-enjoyability").text(enjoy_val);
      $(".current-enjoyability").css("background-color", "#FFFF00");
    } 

    $( ".enjoyability-slider" ).slider({
      step: 1,
      min: 1,
      max: 5,
      value: enjoy_val,
      slide: function(event, ui) {
        enjoy_radios[ui.value-1].click();
        $(".current-enjoyability").text(ui.value);
        if (ui.value < 3)
          $(".current-enjoyability").css("background-color", "#FF1111");
        else if (ui.value < 5)
          $(".current-enjoyability").css("background-color", "#FFFF00");
        else
          $(".current-enjoyability").css("background-color", "#00BB00");
      }
    });

    var diff_radios = $("input[id*=review_difficulty]");
    var selected_difficulty = $("input[id*=review_difficulty]:checked");
    if (selected_difficulty.length > 0)
    {

      var diff_val = selected_difficulty.val();
      $(".current-difficulty").text(diff_val);

      if (diff_val < 3)
        $(".current-difficulty").css("background-color", "#00BB00");
      else if (diff_val < 4.5)
        $(".current-difficulty").css("background-color", "#FFFF00");
      else
        $(".current-difficulty").css("background-color", "#FF1111");
    }
    else
    {
      var diff_val = 3;
      diff_radios[2].click();
      $(".current-difficulty").text(diff_val);
      $(".current-difficulty").css("background-color", "#FFFF00");
    } 

    $( ".difficulty-slider" ).slider({
      step: 1,
      min: 1,
      max: 5,
      value: diff_val,
      slide: function(event, ui) {
        diff_radios[ui.value-1].click();
        $(".current-difficulty").text(ui.value);
        if (ui.value < 3)
          $(".current-difficulty").css("background-color", "#00BB00");
        else if (ui.value < 5)
          $(".current-difficulty").css("background-color", "#FFFF00");
        else
          $(".current-difficulty").css("background-color", "#FF1111");
      }
    });


    var recommend_radios = $("input[id*=review_recommend]");
    var selected_recommend = $("input[id*=review_recommend]:checked");
    if (selected_recommend.length > 0)
    {

      var recommend_val = selected_recommend.val();
      $(".current-recommend").text(recommend_val);

      if (recommend_val < 3)
        $(".current-recommend").css("background-color", "#FF1111");
      else if (recommend_val < 4.5)
        $(".current-recommend").css("background-color", "#FFFF00");
      else
        $(".current-recommend").css("background-color", "#00BB00");
    }
    else
    {
      var recommend_val = 3;
      recommend_radios[2].click();
      $(".current-recommend").text(recommend_val);
      $(".current-recommend").css("background-color", "#FFFF00");
    } 

    $( ".recommend-slider" ).slider({
      step: 1,
      min: 1,
      max: 5,
      value: recommend_val,
      slide: function(event, ui) {
        recommend_radios[ui.value-1].click();
        $(".current-recommend").text(ui.value);
        if (ui.value < 3)
          $(".current-recommend").css("background-color", "#FF1111");
        else if (ui.value < 5)
          $(".current-recommend").css("background-color", "#FFFF00");
        else
          $(".current-recommend").css("background-color", "#00BB00");
      }
    });
  }
});