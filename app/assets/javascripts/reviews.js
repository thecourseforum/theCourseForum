$(document).ready(function() {
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
    else if (!$("input[name=review\\[enjoyability\\]]").is(":checked"))
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

});