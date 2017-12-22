import refreshWithTurbolinks from "./turbolinks-refresh";

$(document).on("click", "a[data-submit=parent], a[data-turbolinks=refresh]", function(event) {
  event.preventDefault();
  const link = $(this);

  const message = event.target.getAttribute("data-confirm");
  if (message === null || confirm(message)) {
    if (link.attr("data-turbolinks") === "refresh") {
      refreshWithTurbolinks(link);
    } else {
      event.target.parentNode.submit();
    }
  };
});
