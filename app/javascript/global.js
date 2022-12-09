$(document).ready(function(){
  // hover for group action button
  $('.btn-group-action').hover(function() {
    $(this).parents('.btn-group-action-wrapper').css('background-color', '#e8eaed');
  }, function() {
    $(this).parents('.btn-group-action-wrapper').css('background-color', '');
  });

  // "render" sidekiq iframe in modal
  $(document).on('click','.sidekiq_modal',function(){
    $("#sidekiq-modal-iframe").html('<iframe src="/sidekiq/busy?poll=true" frameborder="0" class="full-iframe-row"></iframe>');
    new bootstrap.Modal(document.getElementById('sidekiq-modal')).show();
  });
  $('#sidekiq-modal').on('hide.bs.modal', function (e) {
    $("#sidekiq-modal-iframe").html("");
  });
});