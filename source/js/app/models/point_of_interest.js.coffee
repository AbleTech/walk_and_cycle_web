define ["backbone", "app"], (Backbone, App)->
  class PointOfInterest extends Backbone.Model
    sprite_coords:
      airport: [2,2]
      bike_shop: [26, 2]
      bus_stop: [50, 2]
      church: [74, 2]
      council_building: [98, 2]
      cycle_rake: [2, 26]
      drinking_fountain: [26, 26]
      hospital: [50, 26]
      information: [74, 26]
      landmark: [98, 26]
      library: [2, 50]
      museum: [26, 50]
      park: [50, 50]
      playground: [74, 50]
      pool: [98, 50]
      post_office: [2, 74]
      rec_centre: [26, 74]
      reserve: [50, 74]
      school: [74, 74]
      seat: [98, 74]
      shopping_mall: [2, 98]
      skatepark: [26, 98]
      steps: [50, 98]
      streetlight: [74, 98]
      theatre: [98, 98]
      toilet: [122, 2]
      trafficlight: [122, 26]
      zebracrossing: [122, 50]

    initialize: ->
      @on "add", @enter
      @on "remove", @exit

    enter: =>
      @marker().setMap(App.map)

    exit: =>
      @marker().setMap(null)

    marker: ->
      @_marker ||= new google.maps.Marker
        position: @latlng()
        title: @get("title")
        icon: @icon()

    icon: ->
      url: "img/poi_markers.png"
      anchor: new google.maps.Point(10, 10)
      origin: new google.maps.Point(@sprite_coords[@get("poi_type")]...)
      size: new google.maps.Size(20, 20)

    latlng: ->
      @_latlng ||= new google.maps.LatLng(@get("y"), @get("x"))

    parse: (response, options)->
      response.points_of_interest



