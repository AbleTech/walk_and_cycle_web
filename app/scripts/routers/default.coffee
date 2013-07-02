class JourneyPlanner.DefaultRouter extends Backbone.Router
  routes:
    "*query_string": "loadJourney"

  loadJourney: ()->
    params = $.deparam.querystring()

    @journey?.clearMap()
    @journey = new JourneyPlanner.Models.Journey {mode: params.mode}
    if params.waypoints?.length >= 2
      @journey.waypoints.add params.waypoints
    else
      @journey.waypoints.add [{},{}]

    JourneyPlanner.App.resultsRegion.show new JourneyPlanner.Views.Sidebar({model: @journey, collection: @journey.steps})
    JourneyPlanner.App.journeyFields.show new JourneyPlanner.Views.JourneyForm({model: @journey, collection: @journey.waypoints})
    @journey.fetch() if @journey.isValid()
