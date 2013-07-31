define ["jquery", "marionette", "lib/jp_map", "app/routers/default", "app/collections/example_journeys", "app/views/composites/example_list"],
($, Marionette, JPMap, DefaultRouter, ExampleJourneys, ExampleList)->

  window.App = new Marionette.Application()

  App.addRegions
    resultsRegion: $("#results")
    examplesRegion: $("#examples")
    journeyFields: $("#journey_form fieldset")
    detailContent: $("#detail_content")

  App.addInitializer (options)->
    $(window).resize ->
      panel_height = $(window).height() - 150
      $(".left_sidebar").height(panel_height)
      $(".right_body").css("height", panel_height)
    $(window).trigger("resize")

  App.addInitializer (options)->
    @map = new JPMap document.getElementById('mapdiv')
    @map.updateOverlay($.cookie("jp_overlay")) if $.cookie("jp_overlay")?

  App.addInitializer (options)->
    @all_examples = new ExampleJourneys()
    @example_view = new ExampleList()
    @examplesRegion.show @example_view

  App.addInitializer (options)->
    @showResults = =>
      @example_view.collection.hideOverlays()
      @router?.journey?.showOverlays(@map)
    @showExamples = =>
      @example_view.collection.showOverlays(@map)
      @router?.journey?.hideOverlays()

    $("a[href='#examples']").on "show", @showExamples
    $("a[href='#results']").on "show", @showResults

  App.addInitializer ->
    $("#overlay-options li a").click (e)=>
      @map.updateOverlay($(e.target).data("overlay"))
      $("#overlay-options").dropdown("toggle")
      false
    $("#maptype-options li a").click (e)=>
      @map.updateMaptype($(e.target).data("maptype"))
      $("#maptype-options").dropdown("toggle")
      false

  App.addInitializer (options)->
    $("#journey_form").submit (e)=>
      query_str = unescape($("#journey_form").serialize())
      @router.navigate("?#{query_str}", {trigger: true, replace: true})
      false

  App.addInitializer (options)->
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

  App.addInitializer (options)->
    @router = new DefaultRouter()
    @on "initialize:after", =>
      Backbone.history.start({pushState: true, root: document.location.pathname, hashChange: false}) if Backbone.history
