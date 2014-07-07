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
      $("#prof_select").prop("disabled", false);
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
      $(".current-prof-rating").text(prof_val);
    }
    else
    {
      var prof_val = 3;
      prof_radios[2].click();
      $(".current-prof-rating").text(prof_val);
    }  

    $( ".prof-rating-slider" ).slider({
      step: 1,
      min: 100,
      max: 500,
      value: prof_val*100,
      slide: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100); 
        prof_radios[val-1].click();
        $(".current-prof-rating").text(val);
      },
      stop: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100) * 100;      
        $( ".prof-rating-slider" ).slider('value', val);
      }
    });

    var enjoy_radios = $("input[id*=review_enjoyability]");
    var selected_enjoy = $("input[id*=review_enjoyability]:checked");
    if (selected_enjoy.length > 0)
    {

      var enjoy_val = selected_enjoy.val();
      $(".current-enjoyability").text(enjoy_val);
    }
    else
    {
      var enjoy_val = 3;
      enjoy_radios[2].click();
      $(".current-enjoyability").text(enjoy_val);
    } 

    $( ".enjoyability-slider" ).slider({
      step: 1,
      min: 100,
      max: 500,
      value: enjoy_val*100,
      slide: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100); 
        enjoy_radios[val-1].click();
        $(".current-enjoyability").text(val);
      },
      stop: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100) * 100;      
        $( ".enjoyability-slider" ).slider('value', val);
      }
    });

    var diff_radios = $("input[id*=review_difficulty]");
    var selected_difficulty = $("input[id*=review_difficulty]:checked");
    if (selected_difficulty.length > 0)
    {

      var diff_val = selected_difficulty.val();
      $(".current-difficulty").text(diff_val);
    }
    else
    {
      var diff_val = 3;
      diff_radios[2].click();
      $(".current-difficulty").text(diff_val);
    } 

    $( ".difficulty-slider" ).slider({
      step: 1,
      min: 100,
      max: 500,
      value: diff_val*100,
      slide: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100); 
        diff_radios[val-1].click();
        $(".current-difficulty").text(val);
      },
      stop: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100) * 100;      
        $( ".difficulty-slider" ).slider('value', val);
      }
    });


    var recommend_radios = $("input[id*=review_recommend]");
    var selected_recommend = $("input[id*=review_recommend]:checked");
    if (selected_recommend.length > 0)
    {

      var recommend_val = selected_recommend.val();
      $(".current-recommend").text(recommend_val);
    }
    else
    {
      var recommend_val = 3;
      recommend_radios[2].click();
      $(".current-recommend").text(recommend_val);
    } 

    $( ".recommend-slider" ).slider({
      step: 1,
      min: 100,
      max: 500,
      value: recommend_val*100,
      slide: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100); 
        recommend_radios[val-1].click();
        $(".current-recommend").text(val);
      },
      stop: function(event, ui) {
        var val = parseInt((ui.value + 50) / 100) * 100;      
        $( ".recommend-slider" ).slider('value', val);
      }
    });
  }

  $('[id^="vote_up_"]').click(function(){

    var review_id = this.id.match(/\d+/)[0];

    $.ajax({
      url: '/vote_up/' + review_id,
      type: 'POST',
      success: function()
      {
        $("#vote_up_" + review_id).css("background-color", "#d9551e");
        $("#vote_up_" + review_id).css("border-color", "#d9551e");
        $("#vote_up_" + review_id).css("opacity", "1");

        $("#vote_down_" + review_id).css("background-color", "#d9551e");
        $("#vote_down_" + review_id).css("border-color", "#d9551e");
        $("#vote_down_" + review_id).css("opacity", "0.4");
      }
    });

    
  });

  $('[id^="vote_down_"]').click(function(){

    var review_id = this.id.match(/\d+/)[0];
    
    $.ajax({
      url: '/vote_down/' + review_id,
      type: 'POST',
      success: function()
      {
        $("#vote_down_" + review_id).css("background-color", "#d9551e");
        $("#vote_down_" + review_id).css("border-color", "#d9551e");
        $("#vote_down_" + review_id).css("opacity", "1");

        $("#vote_up_" + review_id).css("background-color", "#d9551e");
        $("#vote_up_" + review_id).css("border-color", "#d9551e");
        $("#vote_up_" + review_id).css("opacity", "0.4");

      }
    });


  });

});