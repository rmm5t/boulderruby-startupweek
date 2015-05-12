$ = jQuery

# Enable pusher logging - don't include this in production
# Pusher.log = (message) -> if (window.console && window.console.log) then window.console.log(message)

window.subscriptions = [
  { name: "general", channel: pusher.subscribe('private-general'), description: "This channel is for team-wide communication and announcements. All team members are in this channel." }
  { name: "random",  channel: pusher.subscribe('private-random'),  description: "A place for non-work banter, links, articles of interest, humor or anything else which you'd like concentrated in some place other than work-related channels." }
]

pusher.bind "client-new-message", (data) ->
  displayMessage($.parseJSON(event.data).channel, data)

findSub = (channelName) ->
  (sub for sub in subscriptions when sub.channel.name is channelName)[0]

bumpUnread = (channelName) ->
  tab = $("##{channelName}-tab")
  unless tab.hasClass("active")
    badge = tab.find(".badge")
    unread = parseInt(badge.text()) || 0
    tab.find(".badge").text(unread + 1)

activateChannel = (channelName) ->
  $("##{channelName}-tab").find(".badge").text("")
  $("##{channelName}").find("input").focus()

displayMessage = (channelName, data) ->
  messages = $("##{channelName} .messages")
  messages.append("<p>#{data.body}</p>")
  bumpUnread(channelName)

pushMessage = (channelName, data) ->
  sub = findSub(channelName)
  sub.channel.trigger("client-new-message", data)
  displayMessage(channelName, data)

$(document).ready ->
  tabs     = $("#tabs")
  panes    = $("#panes")

  for sub in subscriptions
    tabs.append("
      <li id='#{sub.channel.name}-tab' role='presentation'>
        <a href='##{sub.channel.name}' data-channel='#{sub.channel.name}' role='tab' data-toggle='tab'>##{sub.name}
        <span class='badge'></span></a>
      </li>")
    panes.append("
      <div role='tabpanel' class='tab-pane' id='#{sub.channel.name}'>
        <div class='entry container-fluid'>
          <form data-channel='#{sub.channel.name}'>
            <input type='text' class='input-lg form-control' />
          </form>
        </div>
        <div class='messages container-fluid'>
          <h1>##{sub.name}</h1>
          <p class='text-muted'>#{sub.description}<p>
        </div>
      </div>")

  $("a[data-toggle=tab]").on "shown.bs.tab", (event) ->
    activateChannel($(event.target).data("channel"))

  $("form").submit (event) ->
    event.preventDefault()
    input = $(this).find("input")
    name  = $(this).data("channel")
    body  = input.val()
    input.val("")
    pushMessage(name, { body: body }) if body

  tabs.find("li a").first().click()
