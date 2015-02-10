var socket = new Phoenix.Socket("/ws")
var constableChannel
var token = "your_token"

socket.join("announcements", {token: token}, function(channel) {
  constableChannel = channel

  channel.on("announcements:index", function(payload) {
    console.log('announcements:index', payload.announcements)
  })

  channel.on("announcements:create", function(announcement) {
    console.log('announcements:create', announcement)
  })

  channel.on("error", function(error) {
    console.log("Failed to join topic. Reason: " + error.reason)
  })

  constableChannel.send("announcements:index", {})
});

socket.join("comments", {token: token}, function(channel) {
  constableCommentChannel = channel

  channel.on("comments:create", function(announcement) {
    console.log('comments:create', announcement)
  })

  constableCommentChannel.send("comments:create", {body: "Something", announcement_id: 1})
});
