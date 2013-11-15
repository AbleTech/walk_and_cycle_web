define ["backbone", "jquery", "app/models/journey", 'app/views/composites/sidebar', 'app/views/composites/journey_form', 'app/views/items/details_content', 'app/views/items/error_sidebar', "jquery.bbq"],
(Backbone, $, Journey, Sidebar, JourneyForm, DetailsContent, ErrorSidebar)->

  class DefaultRouter extends Backbone.Router
    routes:
      "*query_string": "loadJourney"

    loadJourney: ()->
      params = $.deparam.querystring()

      @journey?.hideOverlays()
      if params.example?
        @journey = new Journey {example: params.example}
        @journey.waypoints.add [{},{}]
      else
        @journey = new Journey {mode: params.mode}
        if params.waypoints?.length >= 2
          @journey.waypoints.add _(params.waypoints).compact()
        else
          @journey.waypoints.add [{},{}]
          App.showExamples()
      @renderJourney()

    renderJourney: ->
      App.resultsRegion.show new Sidebar({model: @journey, collection: @journey.steps})
      App.journeyFields.show new JourneyForm({model: @journey, collection: @journey.waypoints})
      App.detailContent.show new DetailsContent({model: @journey})
      if @journey.isValid()
        $("#global_loading_indicator").show()
        @journey.fetch
          success: -> $("#global_loading_indicator").hide()
          error: =>
            $("#global_loading_indicator").hide()
            App.resultsRegion.show new ErrorSidebar({model: @journey})
