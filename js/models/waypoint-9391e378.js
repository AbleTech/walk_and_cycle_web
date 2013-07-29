!function(){var t,e,n=function(t,e){return function(){return t.apply(e,arguments)}},r={}.hasOwnProperty,o=function(t,e){function n(){this.constructor=t}for(var o in e)r.call(e,o)&&(t[o]=e[o]);return n.prototype=e.prototype,t.prototype=new n,t.__super__=e.prototype,t};JourneyPlanner.Models.Waypoint=function(e){function r(){return this.updateWaypoint=n(this.updateWaypoint,this),t=r.__super__.constructor.apply(this,arguments)}return o(r,e),r.prototype.initialize=function(){var t=this;return this.on("remove",function(){return t.getMarker().setMap(null)})},r.prototype.defaults=function(){return{a:"",x:"",y:""}},r.prototype.getMarker=function(){return null!=this._marker?this._marker:(this._marker=new google.maps.Marker({icon:this.iconStyle(),title:this.get("a"),position:this.getLatLng(),draggable:!0}),google.maps.event.addListener(this._marker,"dragend",this.updateWaypoint),this._marker)},r.prototype.index=function(){return this.collection.indexOf(this)},r.prototype.iconStyle=function(){switch(this.get("type")){case"start":return{url:"img/waypoint_markers/start.png",scaledSize:new google.maps.Size(52,27),anchor:new google.maps.Point(19,27)};case"via":return{url:"img/waypoint_markers/via.png",scaledSize:new google.maps.Size(40,27),anchor:new google.maps.Point(14,27)};case"end":return{url:"img/waypoint_markers/end.png",scaledSize:new google.maps.Size(41,27),anchor:new google.maps.Point(14,27)};default:return{}}},r.prototype.getLatLng=function(){return this._latlng||(this._latlng=new google.maps.LatLng(this.get("y"),this.get("x")))},r.prototype.streetName=function(){return this.get("a").split(",")[0]},r.prototype.queryStr=function(){return"waypoints["+this.index()+"][a]="+escape(this.get("a"))+"&waypoints["+this.index()+"][x]="+escape(this.get("x"))+"&waypoints["+this.index()+"][y]="+escape(this.get("y"))},r.prototype.validate=function(t){var e;return e=[],t.x||e.push("missing x coordinate"),t.y?void 0:e.push("missing y coordinate")},r.prototype.updateWaypoint=function(){var t,e=this;return t=this.getMarker().getPosition(),AddressService.ClosestAddress.find(t.lat(),t.lng(),function(n){return n?(e.set({a:n.a,x:t.lng(),y:t.lat()}),e.trigger("update_point")):void 0})},r}(Backbone.Model),JourneyPlanner.Collections.Waypoints=function(t){function n(){return e=n.__super__.constructor.apply(this,arguments)}return o(n,t),n.prototype.model=JourneyPlanner.Models.Waypoint,n}(Backbone.Collection)}.call(this);