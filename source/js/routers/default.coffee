class JourneyPlanner.DefaultRouter extends Backbone.Router
  routes:
    "*query_string": "loadJourney"

  loadJourney: ()->
    params = $.deparam.querystring()

    @journey?.hideOverlays()
    if params.example?
      @journey = new JourneyPlanner.Models.Journey {example: params.example}
      @journey.waypoints.add [{},{}]
    else
      @journey = new JourneyPlanner.Models.Journey {mode: params.mode}
      if params.waypoints?.length >= 2
        @journey.waypoints.add _(params.waypoints).compact()
      else
        @journey.waypoints.add [{},{}]
        JourneyPlanner.App.showExamples()
    @renderJourney()

  renderJourney: ->
    JourneyPlanner.App.resultsRegion.show new JourneyPlanner.Views.Sidebar({model: @journey, collection: @journey.steps})
    JourneyPlanner.App.journeyFields.show new JourneyPlanner.Views.JourneyForm({model: @journey, collection: @journey.waypoints})
    JourneyPlanner.App.detailContent.show new JourneyPlanner.Views.DetailsContent({model: @journey})
    if @journey.isValid()
      $("#global_loading_indicator").show()
      @journey.fetch
        success: ->  $("#global_loading_indicator").hide()
