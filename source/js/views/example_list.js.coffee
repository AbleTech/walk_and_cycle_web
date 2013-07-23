class JourneyPlanner.Views.ExampleItem extends Marionette.ItemView
  tagName : "li"
  template: JST["templates/example_item"]
  events:
    "click a.journey_name": "showExample"
    "mouseover" : "hoverEnter"
    "mouseout" : "hoverExit"

  modelEvents:
    "highlight" : "highlight"
    "unhighlight":"unhighlight"

  hoverEnter: ->
    @model.highlight()
  hoverExit: ->
    @model.unhighlight()

  highlight: ->
    $(@el).addClass "highlight"

  unhighlight: ->
    $(@el).removeClass "highlight"

  showExample: (e)->
    e.preventDefault()
    JourneyPlanner.App.router.navigate("?example=#{@model.id}", {trigger: true, replace: true})
    false



class JourneyPlanner.Views.ExampleList extends Marionette.CompositeView
  itemView: JourneyPlanner.Views.ExampleItem
  itemViewContainer: "ol"
  template: JST["templates/example_list"]

  events:
    "click #example_modes a": "updateMode"
  collectionEvents:
    "update_mode":"render"

  updateMode: (e)->
    @collection.updateMode $(e.target).data("mode")


  appendHtml: (collectionView, itemView, index)->
    collectionView.$("ol").append(itemView.el) if itemView.model.visible()

