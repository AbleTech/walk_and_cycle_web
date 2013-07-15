class JourneyPlanner.Views.WaypointFields extends Marionette.ItemView
  tagName: "div"
  className: 'control-group'
  template: JST["templates/waypoint_fields"]

  modelEvents:
    "change" : "render"
    "update_point" : "submitForm"

  events:
    "click a.close": "removeWaypoint"

  onRender: ->
    prefix = "waypoint_#{@model.index()}"
    element = $("##{prefix}_a", @el)[0]
    new SearchWidget(element,{prefix: prefix})

  templateHelpers:->
    fieldIndex: => @model.index()
    showClose: => (@model.collection.length > 2)

  removeWaypoint: ->
    @model.collection.remove(@model)
    false

  submitForm: ->
    $(@el).parent("form").submit()


class JourneyPlanner.Views.JourneyForm extends Marionette.CompositeView
  itemView: JourneyPlanner.Views.WaypointFields
  itemViewContainer: "#waypoints"
  template: JST["templates/journey_form"]
  events:
    "click a.add-waypoint" : "addWaypoint"

  templateHelpers:->
    modeActive: (mode)=> if @model.get("mode") == mode then "active" else ""
    modeChecked: (mode)=> if @model.get("mode") == mode then "checked" else ""

  addWaypoint: ->
    @collection.add({})
    false
