#= require_self
#= require_tree ./models
#= require_tree ./routers
#= require_tree ./templates
#= require_tree ./views
#= require search_widget
#= require address_services
#= require elevation_graph

'use strict'
window.JourneyPlanner =
  Models: {}
  Collections: {}
  Views: {}
  App: new Marionette.Application()

JourneyPlanner.SPEEDS =
  walking:
    slow: 3
    average: 5
    fast: 6.5
  cycling:
    slow: 10
    average: 20
    fast: 30

JourneyPlanner.CAR_COST =
  walking: 0.7
  cycling: 0.65

JourneyPlanner.HEALTH_COST =
  walking: 3.53
  cycling: 1.77

JourneyPlanner.EFFORT =
  walking:
    slow:     0.0471
    average:  0.0761
    fast:     0.0971
  cycling:
    slow:     0.0690
    average:  0.1500
    fast:     0.2401


JourneyPlanner.App.addRegions
  resultsRegion: $("#results")
  journeyFields: $("#journey_form fieldset")
  detailContent: $("#detail_content")

JourneyPlanner.App.addInitializer ->
  @updateOverlay = (overlay)=>
    @current_overlay?.setMap(null)
    @current_overlay = switch overlay
      when "paths" then @bike_layer
      when "poi" then @pois
      when "traffic" then @traffic_layer
      when "weather" then @weather_layer
    @current_overlay?.setMap(@map)
    $.cookie("jp_overlay", overlay)

  @updateMaptype = (maptype)=>
    new_maptype = switch maptype
      when "map" then google.maps.MapTypeId.ROADMAP
      when "terrain" then google.maps.MapTypeId.TERRAIN
      when "aerial" then google.maps.MapTypeId.HYBRID
    @map.setMapTypeId(new_maptype)

  $("#overlay-options li a").click (e)=>
    @updateOverlay($(e.target).data("overlay"))
    $("#overlay-options").dropdown("toggle")
    false
  $("#maptype-options li a").click (e)=>
    @updateMaptype($(e.target).data("maptype"))
    $("#maptype-options").dropdown("toggle")
    false

JourneyPlanner.App.addInitializer (options)->
  map_opts =
    center: new google.maps.LatLng(-41.105, 175.288)
    zoom: 9
    mapTypeId: $.cookie("jp_maptype") || google.maps.MapTypeId.ROADMAP
    scaleControl: true
    mapTypeControl: false

  @map = new google.maps.Map document.getElementById('mapdiv'), map_opts

  google.maps.event.addListener @map, "maptypeid_changed", =>
    $.cookie "jp_maptype", @map.getMapTypeId()

  @pois = new JourneyPlanner.Collections.PointsOfInterest()

  @weather_layer = new google.maps.weather.WeatherLayer
    temperatureUnits: google.maps.weather.TemperatureUnit.CELCIUS

  @bike_layer = new google.maps.KmlLayer "http://journeyplanner.org.nz/mobile_combined-0.2.1.kml",
    clickable: false
    preserveViewport: true
    suppressInfoWindows: true

  @traffic_layer = new google.maps.TrafficLayer()

  @updateOverlay($.cookie("jp_overlay")) if $.cookie("jp_overlay")?

JourneyPlanner.App.addInitializer (options)->
  $("#journey_form").submit (e)=>
    query_str = unescape($("#journey_form").serialize())
    @router.navigate("?#{query_str}", {trigger: true, replace: true})
    false

JourneyPlanner.App.addInitializer (options)->
  $("#detail_toggle").click =>
    if $(".right_body").hasClass("expanded")
      $(".right_body").removeClass("expanded")
      $("#detail_toggle").html("<i class='icon-double-angle-up'></i> expand")
    else
      $(".right_body").addClass("expanded")
      $("#detail_toggle").html("<i class='icon-double-angle-down'></i> hide")
    setTimeout =>
      google.maps.event.trigger(@map, 'resize')
    , 500
    false

JourneyPlanner.App.addInitializer (options)->
  $(window).resize ->
    panel_height = $(window).height() - 150
    $(".left_sidebar").height(panel_height)
    $(".right_body").css("height", panel_height)
  $(window).trigger("resize")

JourneyPlanner.App.addInitializer (options)->
  @router = new JourneyPlanner.DefaultRouter()
  Backbone.history.start({pushState: true})

$(document).ready ->
  JourneyPlanner.App.start()


