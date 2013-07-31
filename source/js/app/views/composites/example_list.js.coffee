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
      App.all_examples.on "reset", =>
        @collection.reset @filteredData()
      super

    filteredData: ->
      _(App.all_examples.where({mode: @mode})).collect (model)-> model.toJSON()

    updateMode: (e)->
      @mode = $(e.target).data("mode")
      $("#example_modes a").removeClass("selected")
      @collection.hideOverlays()
      $(e.target).addClass("selected")
      @collection.reset @filteredData()
      @collection.showOverlays(App.map)
      false

    templateHelpers:->
      modeSelected: (mode)=> if @mode == mode then "selected" else ""
