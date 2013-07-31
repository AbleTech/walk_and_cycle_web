define ["jquery", "marionette", "lib/search_widget"], ($, Marionette, SearchWidget)->

  class WaypointFields extends Marionette.ItemView
    tagName: "div"
    className: 'control-group'
    template: JST["app/templates/waypoint_fields"]

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
      $(@el).parents("form").submit()

