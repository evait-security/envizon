var toastElList = [].slice.call(document.querySelectorAll('.toast'))
var toastList = toastElList.map(function (toastEl) {
  return new bootstrap.Toast(toastEl, option)
})
$('.btn-group-action').hover(function() {
  $(this).parents('.btn-group-action-wrapper').css('background-color', '#e8eaed');
}, function() {
  $(this).parents('.btn-group-action-wrapper').css('background-color', '');
});
