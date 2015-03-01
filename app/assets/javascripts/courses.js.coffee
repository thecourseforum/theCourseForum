# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
  $('input[name=professor-id]').change () ->
    course_id = window.location.pathname.split('/')[2]
    professor_id = $("input[name='professor-id']:checked").attr('id').split('-')[1]
    window.location.href='/courses/' + course_id + '?p=' + professor_id