const watchTitle = function() {
  const title = $('#announcement_title');
  title.on('input', saveTitle);

  if (title.val() === '') {
    title.val(localStorage.getItem('title'));
  }

  title.trigger('input');
}

const saveTitle = function(e) {
  localStorage.setItem('title', e.target.value);
}

const watchBody = function() {
  const body = $('#announcement_body');
  body.on('input', saveBody);

  if (body.val() === '') {
    body.val(localStorage.getItem('markdown'));
  }

  body.trigger('input');
}

const saveBody = function(e) {
  localStorage.setItem('markdown', e.target.value);
}

const setupInterestsSelect = function() {
  const interests = $('#announcement_interests');
  interests.on('change', saveInterests);

  if (interests.val() === '') {
    const selectize = interests.selectize()[0].selectize;
    const interestNames = localStorage.getItem('interests').split(',');
    selectize.setValue(interestNames);
  }
}

const saveInterests = function(e) {
  localStorage.setItem('interests', e.target.value);
}

const clearLocalStorageOnSubmit = function() {
  $('[data-role=announcement-form]').on('submit', function() {
    localStorage.removeItem('title');
    localStorage.removeItem('interests');
    localStorage.removeItem('markdown');
  });
};

export function setupForm() {
  watchTitle();
  watchBody();
  setupInterestsSelect();
  clearLocalStorageOnSubmit();
}
