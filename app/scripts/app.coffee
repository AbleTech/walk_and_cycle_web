`/*global define */`
define [], ->
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
    @journey = new JourneyPlanner.Models.Journey()
    @journey.waypoints.add [{},{}]
    JourneyPlanner.App.resultsRegion.show new JourneyPlanner.Views.Sidebar({collection: @journey.steps})
    JourneyPlanner.App.journeyFields.show new JourneyPlanner.Views.JourneyForm({model: @journey, collection: @journey.waypoints})
    $("#journey_form").submit (e)=>
      @journey.params = $("#journey_form").serialize()
      @journey.fetch()
      false

  JourneyPlanner.App.addInitializer (options)->
    $(window).resize ->
      $(".left_sidebar, .right_body").height($(window).height() - 150)
    $(window).trigger("resize")


  require ["models/journey", "models/waypoint", "models/step", "views/journey_form", "views/sidebar"], ->
    JourneyPlanner.App.start()


