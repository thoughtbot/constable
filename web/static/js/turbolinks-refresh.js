const refreshWithTurbolinks = function(link) {
  saveScrollPosition()
  sendLinkWithAjax(link)
};

const shouldRestoreScrollPosition = function() {
  return window.turbolinksPreviousScrollPosition !== null;
}

const saveScrollPosition = function() {
  window.turbolinksPreviousScrollPosition = $(window).scrollTop();
}

const sendLinkWithAjax = function(link) {
  var form = $(link.parent());

  $.ajax({
    type: "POST",
    url: form.attr("action"),
    data: form.serialize()
  })
  .done(refreshPageWithTurbolinks)
}

const refreshPageWithTurbolinks = function() {
  var path = window.location.pathname + window.location.search;
  Turbolinks.clearCache();
  Turbolinks.visit(path, { action: 'replace' });
}

const maybeRestoreScrollPosition = function() {
  if (shouldRestoreScrollPosition()) {
    window.scrollTo(0, window.turbolinksPreviousScrollPosition);
    window.turbolinksPreviousScrollPosition = null;
  }
}

$(document).on("turbolinks:render", maybeRestoreScrollPosition)

export default refreshWithTurbolinks;
