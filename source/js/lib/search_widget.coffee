define ["jquery"], ($)->
  class window.SearchWidget extends AddressFinder.Widget
    constructor: (element, options)->
      options.manual_style = true
      options.address_params ?= {}
      options.address_params.region_code = "F"
      options.location_params ?= {}
      options.location_params.region_code = "F"
      super(element,"d1707a90-fd84-012c-d9c3-00e08121877f",options)
      @prefix = options.prefix
      @on "address:select", (value,data)=>
        @populateFields(value, data.x, data.y)
      @on "location:select", (value,data)=>
        @populateFields(value, data.x, data.y)

      @addPOIService()

      @addGPSService() if Modernizr.geolocation

    populateFields:(a,x,y)->
      $("##{@prefix}_a").val(a)
      $("##{@prefix}_x").val(x)
      $("##{@prefix}_y").val(y)

    addPOIService: ->
      @poi_service = @addService "poi-location", (query, response_fn)->
        $.getJSON "http://jp-poi-search.journeyplanner.org.nz/search?callback=?", {q: query}, (data)=>
          results = for result in data.results[0..4]
            {value: result.a, data: result}
          response_fn(query, results)
      @poi_service.on "result:select", (value, data)=>
        @populateFields(value, data.x, data.y)

    addGPSService: ->
      @gps_service = @addService "gps-location", (query, response_fn)->
        results = [{value: "Current Location"}] if _.str.include "current location", query.toLowerCase()
        response_fn(query, results || [])

      @gps_service.setOption "renderer", (value)->
        "<i class='icon-screenshot'></i> Current Location"

      @gps_service.on "result:select", =>
        navigator.geolocation.getCurrentPosition (loc)=>
          @populateFields("Current Location", loc.coords.longitude, loc.coords.latitude)
