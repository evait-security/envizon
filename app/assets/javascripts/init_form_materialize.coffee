$(document).ready ->
  $('input, textarea').characterCounter()
  $('textarea').trigger('autoresize')
  $('select').material_select()
  $('.datepicker').pickadate
    selectMonths: true
    selectYears: 15

  $('span.help-text').each ->
    $value = $(this)[0].innerHTML
    $(this).addClass 'hide'
    $(this).parents('div.input-field').children('label').attr(
      'data-hint', $value
    )
    return
  return
