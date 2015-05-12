(function() {
  var $, activateChannel, bumpUnread, displayMessage, findSub, i, len, pushMessage, sub;

  $ = jQuery;

  window.subscriptions = [
    {
      name: "general",
      description: "This channel is for team-wide communication and announcements. All team members are in this channel."
    }, {
      name: "random",
      description: "A place for non-work banter, links, articles of interest, humor or anything else which you'd like concentrated in some place other than work-related channels."
    }, {
      name: "yac",
      description: "Yet Another Channel."
    }, {
      name: "music",
      description: "A place to discuss great music."
    }
  ];

  for (i = 0, len = subscriptions.length; i < len; i++) {
    sub = subscriptions[i];
    sub.channel = pusher.subscribe("private-" + sub.name);
  }

  pusher.bind("client-new-message", function(data) {
    return displayMessage($.parseJSON(event.data).channel, data);
  });

  findSub = function(channelName) {
    return ((function() {
      var j, len1, results;
      results = [];
      for (j = 0, len1 = subscriptions.length; j < len1; j++) {
        sub = subscriptions[j];
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
    var link, messages;
    bumpUnread(channelName);
    messages = $("#" + channelName + " .messages");
    if (data.body.match(/^http[^\s<>]+\.(png|jpe?g|gif)$/)) {
      return messages.append($("<p></p>").html("<img src='" + data.body + "'/>"));
    } else if (data.body.match(/^http[^\s<>]+$/)) {
      link = $("<a class='oembed' href='" + data.body + "' target='_blank'>" + data.body + "</a>");
      messages.append($("<p></p>").append(link));
      if ($.embedly.defaults.key) {
        return link.embedly({
          query: {
            maxwidth: 600
          }
        });
      }
    } else {
      return messages.append($("<p></p>").text(data.body));
    }
  };

  pushMessage = function(channelName, data) {
    sub = findSub(channelName);
    sub.channel.trigger("client-new-message", data);
    return displayMessage(channelName, data);
  };

  $(document).ready(function() {
    var j, len1, panes, tabs;
    tabs = $("#tabs");
    panes = $("#panes");
    for (j = 0, len1 = subscriptions.length; j < len1; j++) {
      sub = subscriptions[j];
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
      body = $.trim(input.val());
      if (body) {
        pushMessage(name, {
          body: body
        });
      }
      return input.val("");
    });
    return tabs.find("li a").first().click();
  });

}).call(this);
