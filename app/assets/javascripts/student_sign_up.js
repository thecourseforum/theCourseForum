$(document).ready(function(){
  if ($(".student-sign-up").length > 0){
    $(".major2").hide();
    $(".major3").hide();
    $("#majors_major1").change(function(){
      if ($(this).val() != "") {
        $(".major2").fadeIn("fast");
      }
      else {
        $(".major2").fadeIn("fast");
        $(".major3").fadeIn("fast");
      }
    });
    $("#majors_major2").change(function(){
      if ($(this).val() != "") {
        $(".major3").fadeIn("fast");
      }
      else {
        $(".major3").fadeOut("fast");
      }
    });
  }
});