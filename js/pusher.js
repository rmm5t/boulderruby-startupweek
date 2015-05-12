(function() {
  var $, activateChannel, bumpUnread, displayMessage, findSub, pushMessage;

  $ = jQuery;

  window.subscriptions = [
    {
      name: "general",
      channel: pusher.subscribe('private-general'),
      description: "This channel is for team-wide communication and announcements. All team members are in this channel."
    }, {
      name: "random",
      channel: pusher.subscribe('private-random'),
      description: "A place for non-work banter, links, articles of interest, humor or anything else which you'd like concentrated in some place other than work-related channels."
    }
  ];

  pusher.bind("client-new-message", function(data) {
    return displayMessage($.parseJSON(event.data).channel, data);
  });

  findSub = function(channelName) {
    var sub;
    return ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = subscriptions.length; i < len; i++) {
        sub = subscriptions[i];
        if (sub.channel.name === channelName) {
          results.push(sub);
        }
      }
      return results;
    })())[0];
  };

  bumpUnread = function(channelName) {
    var badge, tab, unread;
    tab = $("#" + channelName + "-tab");
    if (!tab.hasClass("active")) {
      badge = tab.find(".badge");
      unread = parseInt(badge.text()) || 0;
      return tab.find(".badge").text(unread + 1);
    }
  };

  activateChannel = function(channelName) {
    $("#" + channelName + "-tab").find(".badge").text("");
    return $("#" + channelName).find("input").focus();
  };

  displayMessage = function(channelName, data) {
    var messages;
    messages = $("#" + channelName + " .messages");
    messages.append("<p>" + data.body + "</p>");
    return bumpUnread(channelName);
  };

  pushMessage = function(channelName, data) {
    var sub;
    sub = findSub(channelName);
    sub.channel.trigger("client-new-message", data);
    return displayMessage(channelName, data);
  };

  $(document).ready(function() {
    var i, len, panes, sub, tabs;
    tabs = $("#tabs");
    panes = $("#panes");
    for (i = 0, len = subscriptions.length; i < len; i++) {
      sub = subscriptions[i];
      tabs.append("<li id='" + sub.channel.name + "-tab' role='presentation'> <a href='#" + sub.channel.name + "' data-channel='" + sub.channel.name + "' role='tab' data-toggle='tab'>#" + sub.name + " <span class='badge'></span></a> </li>");
      panes.append("<div role='tabpanel' class='tab-pane' id='" + sub.channel.name + "'> <div class='entry container-fluid'> <form data-channel='" + sub.channel.name + "'> <input type='text' class='input-lg form-control' /> </form> </div> <div class='messages container-fluid'> <h1>#" + sub.name + "</h1> <p class='text-muted'>" + sub.description + "<p> </div> </div>");
    }
    $("a[data-toggle=tab]").on("shown.bs.tab", function(event) {
      return activateChannel($(event.target).data("channel"));
    });
    $("form").submit(function(event) {
      var body, input, name;
      event.preventDefault();
      input = $(this).find("input");
      name = $(this).data("channel");
      body = input.val();
      input.val("");
      if (body) {
        return pushMessage(name, {
          body: body
        });
      }
    });
    return tabs.find("li a").first().click();
  });

}).call(this);
