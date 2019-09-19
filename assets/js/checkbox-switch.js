const A11YswitchCheck = function() {
  /**
   * Author: Scott O'Hara
   * Version: 0.1.0
   * License: https://github.com/scottaohara/a11y_styled_form_controls/blob/master/LICENSE
   */
  let el;

  /**
   * Initialize the instance, run all setup functions
   * and attach the necessary events.
   */
  this.init = function(elm) {
    el = elm;
    setRole(el);
    attachEvents(el);
  };

  /**
   * Check default state of element:
   * A toggle button is not particularly useful without JavaScript,
   * so ideally such a button would be set to hidden or disabled, if JS wasn't
   * around to make it function.
   */
  const setRole = function(el) {
    if (el.getAttribute('type') === 'checkbox') {
      el.setAttribute('role', 'switch');
    } else {
      console.error(el.id + ' is not a checkbox...');
    }
  };

  /**
   * Attach keyEvents to toggle buttons
   */
  let keyEvents = function(e) {
    let keyCode = e.keyCode || e.which;

    switch (keyCode) {
      case 13:
        e.preventDefault();
        e.target.click();
        break;
    }
  };

  /**
   * Events for toggle buttons
   */
  const attachEvents = function(el) {
    el.addEventListener('keypress', keyEvents, false);
  };

  return this;
};

$(document).ready(function() {
  $('.checkbox-switch > input[type=checkbox]').each(function(_index) {
    let a11ySwitch = new A11YswitchCheck();
    a11ySwitch.init(this);
  });
});
