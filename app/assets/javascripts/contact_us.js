var ready = function() {
  $(".problem").hide();
  $(".other").hide();

  $("#report_type_feedback").on('change', function(){
    $(".problem").hide();
    $(".other").hide();
    $(".description").hide();
    $(".anonymous").fadeIn("fast");
    $(".feedback").fadeIn("fast");
    $(".description").fadeIn("fast");
  });

  $("#report_type_problem").on('change', function(){
    $(".feedback").hide();
    $(".other").hide();
    $(".description").hide();
    $(".anonymous").fadeIn("fast");
    $(".problem").fadeIn("fast");
    $(".description").fadeIn("fast");
  });

  $("#report_type_other").on('change', function(){
    $(".feedback").hide();
    $(".problem").hide();
    $(".description").hide();
    $(".other").fadeIn("fast");
    $(".description").fadeIn("fast");
    $(".anonymous").hide();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);