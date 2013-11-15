define ["marionette"], (Marionette)->
  class ErrorSidebar extends Marionette.ItemView
    template: JST["app/templates/error_sidebar"]

    templateHelpers: ->
      description: =>
        waypoints = @model.waypoints
        if waypoints.size() > 0
          "<strong>#{waypoints.first().streetName()}</strong> to <strong>#{waypoints.last().streetName()}</strong>"
