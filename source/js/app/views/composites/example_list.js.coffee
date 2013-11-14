define ["jquery", "underscore", "marionette", "app/views/items/example_item", "app/collections/example_journeys"],
($, _, Marionette, ExampleItem, ExampleJourneys)->
  class ExampleList extends Marionette.CompositeView
    itemView: ExampleItem
    itemViewContainer: "ol"
    template: JST["app/templates/example_list"]
    mode: "walking"

    events:
      "click #example_modes a": "updateMode"

    initialize: (options)->
      @collection = new ExampleJourneys @filteredData()
      App.all_examples.on "sync", =>
        @collection.reset @filteredData()
        @collection.showOverlays(App.map) if $(@el).is(":visible")
      super

    filteredData: ->
      conditions = {mode: @mode}
      conditions["region_id"] = parseInt(App.current_region) if App.current_region

      _(App.all_examples.where(conditions)).collect (model)-> model.toJSON()

    updateMode: (e)->
      @mode = $(e.target).data("mode")
      $("#example_modes a").removeClass("selected")
      $(e.target).addClass("selected")
      @resetData(true)
      false

    resetData: (reset_map=false)=>
      @collection.hideOverlays()
      @collection.reset @filteredData()
      @collection.showOverlays(App.map)
      App.map.fitBounds(@collection.boundingBox()) if reset_map

    templateHelpers:->
      modeSelected: (mode)=> if @mode == mode then "selected" else ""
