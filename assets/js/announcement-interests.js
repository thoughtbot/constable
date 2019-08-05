import "selectize";

const DELIMITER = ",";

export default class {
  constructor() {
    this._form = $("[data-role=announcement-form]");
    this._isEditing = !!this._form.data("id");
  }

  loadInterests() {
    return localStorage.getItem("interests");
  }

  setupInterestsSelect(updateInterests) {
    const interests = $("#announcement_interests");

    if (interests.length !== 0) {
      if (interests.val() === "") {
        interests.val(this.loadInterests());
      }

      if (interests[0].selectize) {
        interests[0].selectize.destroy();
      }

      interests.selectize({
        delimiter: DELIMITER,
        persist: false,
        create: function(name) {
          return { name };
        },
        valueField: "name",
        labelField: "name",
        searchField: "name",
        options: window.INTERESTS_NAMES,
        onChange: value => {
          if (!this._isEditing) {
            localStorage.setItem("interests", value);
            updateInterests(value);
          }
        },
      });
    }
  }
}
