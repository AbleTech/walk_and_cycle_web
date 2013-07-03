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

JourneyPlanner.App.addRegions
  resultsRegion: $("#results")
  journeyFields: $("#journey_form fieldset")

JourneyPlanner.App.addInitializer (options)->
  map_opts =
    center: new google.maps.LatLng(-41.105, 175.288)
    zoom: 9
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scaleControl: true

  @map = new google.maps.Map document.getElementById('mapdiv'), map_opts

JourneyPlanner.App.addInitializer (options)->
  @graph = new ElevationGraph()

JourneyPlanner.App.addInitializer (options)->
  $("#journey_form").submit (e)=>
    query_str = unescape($("#journey_form").serialize())
    @router.navigate("?#{query_str}", {trigger: true, replace: true})
    false

JourneyPlanner.App.addInitializer (options)->
  $(window).resize ->
    $(".left_sidebar").height($(window).height() - 150)
    $(".right_body").height($(window).height() - 300)
  $(window).trigger("resize")


JourneyPlanner.App.addInitializer (options)->
  @router = new JourneyPlanner.DefaultRouter()
  Backbone.history.start({pushState: true})

$(document).ready ->
  JourneyPlanner.App.start()


