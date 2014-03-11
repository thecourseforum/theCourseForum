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

});