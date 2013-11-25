#= require_tree ./app/templates

require.config
  paths:
    "jquery": "../components/jquery/jquery"
    "underscore": "../components/underscore/underscore"
    "underscore.string": "../components/underscore.string/dist/underscore.string.min"
    "backbone": "../components/backbone/backbone"
    "marionette": "../components/backbone.marionette/lib/backbone.marionette"
    "jquery.cookie": "../components/jquery.cookie/jquery.cookie"
    "jquery.bbq": "vendor/jquery.bbq"
    "bootstrap": "vendor/bootstrap"
    "marker_with_label": "vendor/markerwithlabel"
    "context_menu": "lib/context_menu"


  shim:
    "backbone":
      deps: ["underscore","jquery"]
      exports: "Backbone"
    "marionette":
      deps: ["backbone"]
      exports: "Marionette"
    "underscore":
      exports: "_"
    "underscore.string":
      deps: ["underscore"]
    "jquery.cookie":
      deps: ["jquery"]
    "jquery.bbq":
      deps: ["jquery"]
    "bootstrap":
      deps: ["jquery"]
    "marker_with_label":
      exports: "MarkerWithLabel"
    "context_menu":
      exports: "ContextMenu"

define ["jquery", "app"], ($)->
  $(document).ready ->
    App.start()

    setTimeout ->
      window.scrollTo(0, 1)
    , 1000
