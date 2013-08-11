$(document).ready(function(){
  $(".major2").hide();
  $(".major3").hide();
  $("#majors_major1").change(function(){
    if ($(this).val() != "") {
      $(".major2").show();
    }
    else {
      $(".major2").hide();
      $(".major3").hide();
    }
  });
  $("#majors_major2").change(function(){
    if ($(this).val() != "") {
      $(".major3").show();
    }
    else {
      $(".major3").hide();
    }
  });
});