define ["backbone", "app", "app/models/example_journey"], (Backbone, App, ExampleJourney)->
  class ExampleJourneys extends Backbone.Collection
    model: ExampleJourney
    mode: "walking"

    resetOverlays:(map=App.map)->
      @forEach (model)=>
        if model.visible()
          model.polyline().setMap(map)
          model.exampleMarker().setMap(map)
        else
          model.polyline().setMap(null)
          model.exampleMarker().setMap(null)

    showOverlays: (map)->
      @forEach (model)=>
        model.polyline().setMap(map)
        model.exampleMarker().setMap(map)

    hideOverlays: ->
      @showOverlays(null)
