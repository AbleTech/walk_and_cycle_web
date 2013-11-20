define ["marionette", "app/views/items/waypoint_fields"], (Marionette, WaypointFields)->
  class JourneyForm extends Marionette.CompositeView
    itemView: WaypointFields
    itemViewContainer: "#waypoints"
    template: JST["app/templates/journey_form"]

    events:
      "click a.add-waypoint" : "addWaypoint"

    collectionEvents:
      "remove" : "render"
      "add" : ->
        @children.each (child)-> child.render()

    templateHelpers:->
      modeActive: (mode)=> if @model.get("mode") == mode then "active" else ""
      modeChecked: (mode)=> if @model.get("mode") == mode then "checked" else ""

    addWaypoint: ->
      @collection.add({})
      false
