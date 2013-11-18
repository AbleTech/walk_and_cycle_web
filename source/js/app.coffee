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
      console.log window.matchMedia("print").matches
      $(".left_sidebar").height(panel_height)
      $(".right_body").css("height", panel_height)
    $(window).trigger("resize")

  App.addInitializer (options)->
    @map = new JPMap document.getElementById('mapdiv')
    @map.updateOverlay($.cookie("jp_overlay")) if $.cookie("jp_overlay")?

  App.addInitializer (options)->
    @all_examples = new ExampleJourneys()
    @all_examples.fetch
      success: =>
        @example_view = new ExampleList()
        @examplesRegion.show @example_view

  App.addInitializer (options)->
    @toggleDetailsPanel = (open=true, callback=null)=>
      $(".right_body").toggleClass("expanded", open)
      if open
        $("#detail_toggle").html("<i class='icon-double-angle-down'></i> hide")
      else
        $("#detail_toggle").html("<i class='icon-double-angle-up'></i> expand")
      google.maps.event.trigger(@map, 'resize')


  App.addInitializer (options)->
    @showResults = =>
      $("#body-content .right_body").removeClass("examples")
      @toggleDetailsPanel(true)
      @example_view?.collection.hideOverlays()
      @router?.journey?.showOverlays(@map)

    @showExamples = =>
      $("#body-content .right_body").addClass("examples")
      @toggleDetailsPanel(false)
      @example_view?.collection.showOverlays(@map)
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
    $("#region_id").change (e)=>
      @current_region = $("#region_id").val()
      @example_view?.resetData(true)

  App.addInitializer (options)->
    $("#detail_toggle").click =>
      @toggleDetailsPanel !$(".right_body").hasClass("expanded")
      false

  App.addInitializer ->
    $("#print-share").click ->
      window.location = "/print_journey#{location.search}"
      false
    $("#facebook-share").click ->
      window.open "https://www.facebook.com/sharer/sharer.php?u=#{encodeURIComponent(location.href)}",
        'facebook-share-dialog',
        'width=626,height=436'
      false

    $("#twitter-share").click ->
      window.open "https://twitter.com/share?url=#{encodeURIComponent(location.href)}&via=greaterwgtn",
        'twitter-share-dialog',
        'width=626,height=436'
      false

    $("#googleplus-share").click ->
      window.open "https://plus.google.com/share?url=#{encodeURIComponent(location.href)}",
        'gplus-share-dialog',
        'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,width=600,height=600'
      false

  App.addInitializer (options)->
    @router = new DefaultRouter()
    @on "initialize:after", =>
      Backbone.history.start({pushState: true, root: document.location.pathname, hashChange: false}) if Backbone.history
