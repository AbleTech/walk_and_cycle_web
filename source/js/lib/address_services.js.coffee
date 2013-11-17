define ["jquery"], ($)->

  AddressService =
    AF_KEY: "d1707a90-fd84-012c-d9c3-00e08121877f"

  class AddressService.ClosestAddress
    instance = null

    @find: (lat, lng, callback)->
      new PrivateClass(lat, lng, callback)

    class PrivateClass
      constructor: (@lat, @lng, @callback)->
        query_options =
          match_type: "addresses"
          x: @lng
          y: @lat
          key: AddressService.AF_KEY
        $.getJSON "http://addressfinder.co.nz/api/address/nearby.json?callback=?", query_options, (data)=>
          @result = data?.completions?[0]
          if @result?
            @fetchInfo()
          else
            @callback(null)


      fetchInfo: ->
        query_options =
          key: AddressService.AF_KEY
          pxid: @result.pxid
        $.getJSON "http://addressfinder.co.nz/api/address/info.json?callback=?", query_options, (data)=>
          @callback(data)

  return AddressService
