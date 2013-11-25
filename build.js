({
    baseUrl: "build/js",
    // include:["vendor/require"],
    paths: {
      "jquery": "../../source/components/jquery/jquery.min",
      "underscore": "../../source/components/underscore/underscore-min",
      "underscore.string": "../../source/components/underscore.string/dist/underscore.string.min",
      "backbone": "../../source/components/backbone/backbone-min",
      "marionette": "../../source/components/backbone.marionette/lib/backbone.marionette.min",
      "jquery.cookie": "../../source/components/jquery.cookie/jquery.cookie",
      "jquery.bbq": "vendor/jquery.bbq",
      "bootstrap": "vendor/bootstrap",
      "marker_with_label": "vendor/markerwithlabel",
      "context_menu": "vendor/context_menu"
    },
    shim: {
      "backbone": {
        deps: ["underscore", "jquery"],
        exports: "Backbone"
      },
      "marionette": {
        deps: ["backbone"],
        exports: "Marionette"
      },
      "underscore": {
        exports: "_"
      },
      "underscore.string": {
        deps: ["underscore"]
      },
      "jquery.cookie": {
        deps: ["jquery"]
      },
      "bootstrap": {
        deps: ["jquery"]
      },
      "marker_with_label":{
        exports: "MarkerWithLabel"
      },
      "context_menu":{
        exports: "ContextMenu"
      }
    },
    name: "main",
    out: "build/js/main.js"
})
