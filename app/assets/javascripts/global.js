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

function copyToClipboard(text) {
  if (window.clipboardData && window.clipboardData.setData) {
      // Internet Explorer-specific code path to prevent textarea being shown while dialog is visible.
      return window.clipboardData.setData("Text", text);

  }
  else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
      var textarea = document.createElement("textarea");
      textarea.textContent = text;
      textarea.style.position = "fixed";  // Prevent scrolling to bottom of page in Microsoft Edge.
      document.body.appendChild(textarea);
      textarea.select();
      try {
        return document.execCommand("copy");  // Security exception may be thrown by some browsers.
      }
      catch (ex) {
        console.warn("Copy to clipboard failed.", ex);
        return prompt("Copy to clipboard: Ctrl+C, Enter", text);
      }
      finally {
        document.body.removeChild(textarea);
      }
  }
}
