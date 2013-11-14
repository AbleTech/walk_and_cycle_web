define ["backbone", "app/models/example_journey", "app"], (Backbone, ExampleJourney)->
  class ExampleJourneys extends Backbone.Collection
    model: ExampleJourney
    mode: "walking"

    url: "http://staging.journeyplanner.org.nz/api/examples.json?callback=?"

    parse: (response)-> response.features

    initialize: ->
      @on "reset", =>
        @_bounds = null

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

    boundingBox: ->
      return @_bounds if @_bounds?
      @_bounds = new google.maps.LatLngBounds()
      @each (model)=> @_bounds = @_bounds.union(model.boundingBox())
      @_bounds
