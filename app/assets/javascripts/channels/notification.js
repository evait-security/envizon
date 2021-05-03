App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    toastr.options.positionClass = "toast-bottom-left";
    toastr.info(data['message']);
  },

  notify: function() {
    return this.perform('notify');
  }
});
