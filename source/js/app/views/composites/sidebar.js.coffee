define ["jquery", "underscore", "marionette", "config", "app/views/items/step_item", "underscore.string", "bootstrap"], ($, _, Marionette, Config, StepItem)->

  class Sidebar extends Marionette.CompositeView
    itemView: StepItem
    itemViewContainer: "ol"
    template: JST["app/templates/journey_sidebar"]

    events:
      "click #pace-dropdown a": "changePace"

    initialize: ->
      @listenTo @model, "change", @render

    changePace: (e)->
      @model.set "pace", $(e.target).data("pace")
      @render()
      false

    onDomRefresh: ->
      $(".dropdown-toggle", @el).dropdown()

    templateHelpers: ->

      loading: =>
        !@model.has("total_distance")

      totalDistance: =>
        if distance = @model.get("total_distance")
          if distance > 1000
            "#{Math.round(distance / 100.0) / 10.0} km"
          else
            "#{Math.round(distance)} m"

      startAddress: (short=false)=>
        start_address = @model.waypoints.first()
        if short then start_address.streetName() else start_address.get("a")

      finishAddress: (short=false)=>
        finish_address = @model.waypoints.last()
        if short then finish_address.streetName() else finish_address.get("a")

      description: =>
        waypoints = @model.waypoints
        if waypoints.size() > 0
          "<strong>#{waypoints.first().streetName()}</strong> to <strong>#{waypoints.last().streetName()}</strong>"

      paceDescription: =>
        _.str.titleize @model.get("pace")

      speedDescription: (pace)=>
        speed = Config.SPEEDS[@model.get("mode")][pace]
        "#{_.str.titleize(pace)} pace - #{speed} km/hr"


      formattedTime: =>
        time = @model.total_time()
        hours     = Math.floor(time/60.0)
        hour_str  = if hours == 1 then "hour" else "hours"
        minutes     = Math.round(time - (hours*60))
        minute_str  = if minutes == 1 then "minute" else "minutes"
        time_str = "#{minutes} #{minute_str}"
        time_str = "#{hours} #{hour_str}, " + time_str if hours > 0
        time_str
