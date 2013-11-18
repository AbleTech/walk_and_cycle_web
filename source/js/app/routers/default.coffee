define ["underscore", "backbone", "jquery", "app/models/journey", 'app/views/composites/sidebar', 'app/views/composites/journey_form', 'app/views/items/details_content', 'app/views/items/error_sidebar', "jquery.bbq"],
(_, Backbone, $, Journey, Sidebar, JourneyForm, DetailsContent, ErrorSidebar)->

  class DefaultRouter extends Backbone.Router
    routes:
      "*query_string": "loadJourney"

    legacyParamMap:[
      {regex: /^x([0-9]*)/, new_key: "x"}
      {regex: /^y([0-9]*)/, new_key: "y"}
      {regex: /^a([0-9]*)/, new_key: "a"}
    ]

    loadJourney: ()->
      params = $.deparam.querystring()
      @fixLegacyParams params
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
      $("#link-modal textarea").val(location.href)
      if @journey.isValid()
        $("title").text "#{@journey.waypoints.first().streetName()} to #{@journey.waypoints.last().streetName()} | Cycling and Walking Journey Planner"
        $("#global_loading_indicator").show()
        @journey.fetch
          success: -> $("#global_loading_indicator").hide()
          error: =>
            $("#global_loading_indicator").hide()
            App.resultsRegion.show new ErrorSidebar({model: @journey})

    fixLegacyParams: (params={})->
      new_params = _(params).clone()
      params.waypoints ||= []
      _(params).each (value, key)=>
        _(@legacyParamMap).each (legacy_param)->
          if (parts = key.match(legacy_param.regex))?
            index = if parts[1] == "" then 0 else parseInt(parts[1],10)
            params.waypoints[index] ||= {}
            params.waypoints[index][legacy_param.new_key] = value
            delete params[key]


