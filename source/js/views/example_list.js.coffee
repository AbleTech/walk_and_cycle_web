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
    @model.showExample()
    false


class JourneyPlanner.Views.ExampleList extends Marionette.CompositeView
  itemView: JourneyPlanner.Views.ExampleItem
  itemViewContainer: "ol"
  template: JST["templates/example_list"]
  mode: "walking"

  events:
    "click #example_modes a": "updateMode"

  initialize: (options)->
    @collection = new JourneyPlanner.Collections.ExampleJourneys @filteredData()
    JourneyPlanner.App.all_examples.on "reset", =>
      @collection.reset @filteredData()
    super

  filteredData: ->
    _(JourneyPlanner.App.all_examples.where({mode: @mode})).collect (model)-> model.toJSON()

  updateMode: (e)->
    @mode = $(e.target).data("mode")
    $("#example_modes a").removeClass("selected")
    @collection.hideOverlays()
    $(e.target).addClass("selected")
    @collection.reset @filteredData()
    @collection.showOverlays(JourneyPlanner.App.map)
    false

  templateHelpers:->
    modeSelected: (mode)=> if @mode == mode then "selected" else ""
