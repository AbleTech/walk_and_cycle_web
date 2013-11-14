define ["backbone", "app/models/point_of_interest"], (Backbone, PointOfInterest)->
  class PointsOfInterest extends Backbone.Collection
    model: PointOfInterest

    url: -> "http://staging.journeyplanner.org.nz/api/poi.json?callback=?&bounds=#{@bounds}&zoom=#{@zoom}"

    setMap: (map)->
      if map? then @show() else @hide()

    show: ->
      @forEach (model)=> model.enter()
      @updateMap()
      @listener = google.maps.event.addListener App.map, "idle", @updateMap

    updateMap: =>
      map = App.map
      if map.getBounds()?
        @bounds = map.getBounds().toUrlValue()
        @zoom = map.getZoom()
        @fetch()

    hide: ->
      google.maps.event.removeListener(@listener) if @listener
      @forEach (model)=> model.exit()
