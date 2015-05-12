$ = jQuery

# Enable pusher logging - don't include this in production
# Pusher.log = (message) -> if (window.console && window.console.log) then window.console.log(message)

window.subscriptions = [
  { name: "general", description: "This channel is for team-wide communication and announcements. All team members are in this channel." }
  { name: "random",  description: "A place for non-work banter, links, articles of interest, humor or anything else which you'd like concentrated in some place other than work-related channels." }
  { name: "music",   description: "A place to discuss great music." }
]

for sub in subscriptions
  sub.channel = pusher.subscribe("private-#{sub.name}")

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
  bumpUnread(channelName)
  messages = $("##{channelName} .messages")
  if data.body.match /^http[^\s<>]+\.(png|jpe?g|gif)$/
    messages.append($("<p></p>").html("<img src='#{data.body}'/>"))
  else if data.body.match /^http[^\s<>]+$/
    link = $("<a class='oembed' href='#{data.body}' target='_blank'>#{data.body}</a>")
    messages.append($("<p></p>").append(link))
    link.embedly(query: { maxwidth: 400 }) if $.embedly.defaults.key
  else
    messages.append($("<p></p>").text(data.body))

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
    body  = $.trim(input.val())
    pushMessage(name, { body: body }) if body
    input.val("")

  tabs.find("li a").first().click()
