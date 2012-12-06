# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready( ->
  $('.calendar').datepicker()

  $('.category-tree').on('click', (e) ->
    e.stopPropagation();
    e.preventDefault();
    $($(this).attr('href')).slideToggle()
    $(this).find('i').toggleClass('icon-plus').toggleClass('icon-minus')
  )
)
