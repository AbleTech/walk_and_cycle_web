class window.SearchWidget extends AddressFinder.Widget
  constructor: (element, options)->
    options.address_params ?= {}
    options.address_params.region_code = "F"
    super(element,"d1707a90-fd84-012c-d9c3-00e08121877f",options)
    @prefix = options.prefix
    @on "address:select", (value,data)=>
      @populateFields(value, data.x, data.y)

    @addGPSService() if Modernizr.geolocation

  populateFields:(a,x,y)->
    $("##{@prefix}_a").val(a)
    $("##{@prefix}_x").val(x)
    $("##{@prefix}_y").val(y)

  addGPSService: ->
    @gps_service = @addService "gps-location", (query, response_fn)->
      results = [{value: "Current Location"}] if _.str.include "current location", query.toLowerCase()
      response_fn(query, results || [])

    @gps_service.setOption "renderer", (value)->
      "<i class='icon-screenshot'></i> Current Location"

    @gps_service.on "result:select", =>
      navigator.geolocation.getCurrentPosition (loc)=>
        @populateFields("Current Location", loc.coords.longitude, loc.coords.latitude)
