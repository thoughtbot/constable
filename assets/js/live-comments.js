import socket from './socket'
import $ from 'jquery'

const channel = socket.channel('live-html', {})

channel.join()
  .receive('ok', function (resp) { console.log('Joined successfully', resp) })
  .receive('error', function (resp) { console.log('Unable to join', resp) })

channel.on('new-comment', payload => {
  $(`[data-announcement-id='${payload.announcement_id}'] .comments-list`)
    .append(payload.comment_html)
})
