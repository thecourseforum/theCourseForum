# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ready = ->
  search = window.location.search.substring(1)
  params = JSON.parse '{"' + decodeURI(search).replace(/"/g, '\"').replace(/&/g, '","').replace(RegExp('=', 'g'), '":"') + '"}'
  $('#check-' + params['p']).prop('checked', true)
  $('input[name=professor-id]').change () ->
    course_id = window.location.pathname.split('/')[2]
    professor_id = $("input[name='professor-id']:checked").attr('id').split('-')[1]
    window.location.href='/courses/' + course_id + '?p=' + professor_id
  $('.courses-review-type-switcher').change () ->
    window.location.href='/courses/' + $(this).val()

$(document).ready(ready)
$(document).on('page:load', ready)