import $ from "jquery"
import socket from "./socket"

const resetForm = (form) => form.reset();
const disableForm = (form) => form.children(":input").attr("disabled", "disabled");
const enableForm = (form) => form.children(":input").removeAttr("disabled");

$(".comment-form").on("submit", function submitForm(event) {
  event.preventDefault();
  var form = $(this);

  $.ajax({
    type: "POST",
    url: form.attr("action"),
    data: form.serialize(),
    beforeSend: () => disableForm(form),
  })
  .done(() => {
    resetForm(form[0]);
    enableForm(form);
  });
});

var channel = socket.channel("live-html", {});

channel.join()
  .receive("ok", function(resp) { console.log("Joined successfully", resp) })
  .receive("error", function(resp) { console.log("Unable to join", resp) })

channel.on("new-comment", payload => {
  $(`[data-announcement-id="${payload.announcement_id}"] .comments-list`)
    .append(payload.comment_html)
})
