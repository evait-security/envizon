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
    $.ajax({
      url: "/notifications/new",
      dataType: "script",
      data: data,
      cache: true
    });
    //alert('Hallo')
    //$("#main-notification-menu").html("<%= j(render('layouts/notifications')) %>");
  },

  notify: function() {
    return this.perform('notify');
  }
});
