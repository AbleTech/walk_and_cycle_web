#= require_self
#= require_tree ./models
#= require_tree ./routers
#= require_tree ./templates
#= require_tree ./views
#= require search_widget
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

JourneyPlanner.App.addInitializer (options)->
  map_opts =
    center: new google.maps.LatLng(-41.105, 175.288)
    zoom: 9
    mapTypeId: $.cookie("jp_maptype") || google.maps.MapTypeId.ROADMAP
    scaleControl: true

  @map = new google.maps.Map document.getElementById('mapdiv'), map_opts

  google.maps.event.addListener @map, "maptypeid_changed", =>
    $.cookie "jp_maptype", @map.getMapTypeId()

# JourneyPlanner.App.addInitializer (options)->
#   @pace  = $.cookie("jp_speed") || "average"
#   @updatePace = (new_pace)=>
#     @pace = new_pace
#     $.cookie("jp_speed", new_pace)

JourneyPlanner.App.addInitializer (options)->
  $("#journey_form").submit (e)=>
    query_str = unescape($("#journey_form").serialize())
    @router.navigate("?#{query_str}", {trigger: true, replace: true})
    false

JourneyPlanner.App.addInitializer (options)->
  $(window).resize ->
    $(".left_sidebar").height($(window).height() - 150)
    $(".right_body").height($(window).height() - 310)
  $(window).trigger("resize")


JourneyPlanner.App.addInitializer (options)->
  @router = new JourneyPlanner.DefaultRouter()
  Backbone.history.start({pushState: true})

$(document).ready ->
  JourneyPlanner.App.start()


