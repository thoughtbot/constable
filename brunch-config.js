var bourbonPath = require("bourbon").includePaths[0];

exports.config = {
  files: {
    javascripts: {
      joinTo: "js/app.js"
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: /^(web\/static\/assets)/
  },

  paths: {
    watched: [
      "web/static",
      "test/static"
    ],

    public: "priv/static"
  },

  plugins: {
    babel: {
      ignore: [/web\/static\/vendor/]
    },

    sass: {
      options: {
        includePaths: [
          bourbonPath,
          "./node_modules/bourbon-neat/app/assets/stylesheets",
        ],
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    whitelist: [
      "jquery",
      "marked",
      "mousetrap",
      "phoenix",
      "selectize",
      "textarea-autogrow",
      "turbolinks",
    ]
  }
};
