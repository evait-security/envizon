App.notification = App.cable.subscriptions.create("UpdateChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel

    // refresh sidebar if user is on group page
    if ($(".groups-page").size()){
      $.ajax({
        url: "/groups/group_list",
        dataType : "script",
        cache: true,
        method: "get"
      });
    }

    // check if selected group should be rerendered
    if( $('.selected-group').attr('gid') !== undefined ){
      var mod_gids = data["ids"].split(",");
      var selected_id = $('.selected-group').attr('gid'); 
      if ((mod_gids.indexOf(selected_id) > -1)){
        // disable db commands for selected group
        $(".grp_delete").addClass("disabled");
        $(".grp_delete_clients").addClass("disabled");
        $(".grp_move").addClass("disabled");
        $(".grp_copy").addClass("disabled");
        $(".grp_new").addClass("disabled");
        $(".grp_scan").addClass("disabled");
        $(".grp_update").removeClass("hidden");
      }
    }
  },

  notify: function() {
    return this.perform('notify');
  }
});
