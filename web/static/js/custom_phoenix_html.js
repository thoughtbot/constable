import $ from "jquery";

$(document).on("click", "a[data-submit=parent]", function(event) {
  event.preventDefault();

  const message = event.target.getAttribute("data-confirm");
  if (message === null || confirm(message)) {
    event.target.parentNode.submit();
  };
});
