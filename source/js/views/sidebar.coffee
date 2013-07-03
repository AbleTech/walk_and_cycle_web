class JourneyPlanner.Views.StepItem extends Marionette.ItemView
  tagName: "li"
  template: JST["templates/step_item"]

class JourneyPlanner.Views.Sidebar extends Marionette.CompositeView
  itemView: JourneyPlanner.Views.StepItem
  itemViewContainer: "ol"
  template: JST["templates/journey_sidebar"]

  initialize: ->
    @listenTo @model, "change", @render

  templateHelpers: ->

    totalDistance: =>
      if distance = @model.get("total_distance")
        if distance > 500
          "#{Math.round(distance / 100.0) / 10.0} km"
        else
          "#{Math.round(distance)} m"

    description: =>
      waypoints = @model.waypoints
      if waypoints.size() > 0
        "#{waypoints.first().streetName()} to #{waypoints.last().streetName()}"
