App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    // alert(data['message']);
    // Materialize.toast(data['message'], 3000, 'blue');
    M.toast({html: "Global: " + data['message'], displayLength: 4000});
  },

  notify: function() {
    return this.perform('notify');
  }
});
