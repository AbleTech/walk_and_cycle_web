class window.JPMap extends google.maps.Map
  map_opts:
    center: new google.maps.LatLng(-41.105, 175.288)
    zoom: 9
    mapTypeId: $.cookie("jp_maptype") || google.maps.MapTypeId.ROADMAP
    scaleControl: true
    mapTypeControl: false

  constructor: (element)->
    super element, @map_opts

    google.maps.event.addListener @, "maptypeid_changed", =>
      $.cookie "jp_maptype", @getMapTypeId()

    @setupLayers()


  setupLayers: ->
    @pois = new JourneyPlanner.Collections.PointsOfInterest()

    @weather_layer = new google.maps.weather.WeatherLayer
      temperatureUnits: google.maps.weather.TemperatureUnit.CELCIUS

    @bike_layer = new google.maps.KmlLayer "http://journeyplanner.org.nz/mobile_combined-0.2.1.kml",
      clickable: false
      preserveViewport: true
      suppressInfoWindows: true

    @traffic_layer = new google.maps.TrafficLayer()

  updateOverlay: (overlay)=>
    @current_overlay?.setMap(null)
    @current_overlay = switch overlay
      when "paths" then @bike_layer
      when "poi" then @pois
      when "traffic" then @traffic_layer
      when "weather" then @weather_layer
    @current_overlay?.setMap(@)
    $.cookie("jp_overlay", overlay)

  updateMaptype: (maptype)=>
    new_maptype = switch maptype
      when "map" then google.maps.MapTypeId.ROADMAP
      when "terrain" then google.maps.MapTypeId.TERRAIN
      when "aerial" then google.maps.MapTypeId.HYBRID
    @setMapTypeId(new_maptype)
