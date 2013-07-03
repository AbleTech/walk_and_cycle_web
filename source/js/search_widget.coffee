class window.SearchWidget extends AddressFinder.Widget
  constructor: (element, options)->
    super(element,"d1707a90-fd84-012c-d9c3-00e08121877f",options)
    @prefix = options.prefix
    @on "address:select", (value,data)=>
      @populateFields(value, data.x, data.y)

  populateFields:(a,x,y)->
    $("##{@prefix}_a").val(a)
    $("##{@prefix}_x").val(x)
    $("##{@prefix}_y").val(y)
