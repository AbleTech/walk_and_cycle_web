!function(){var t={}.hasOwnProperty,e=function(e,r){function o(){this.constructor=e}for(var n in r)t.call(r,n)&&(e[n]=r[n]);return o.prototype=r.prototype,e.prototype=new o,e.__super__=r.prototype,e};define(["jquery","underscore","marionette","config","app/views/items/step_item","underscore.string","bootstrap"],function(t,r,o,n,i){var s,a;return s=function(o){function s(){return a=s.__super__.constructor.apply(this,arguments)}return e(s,o),s.prototype.itemView=i,s.prototype.itemViewContainer="ol",s.prototype.template=JST["app/templates/journey_sidebar"],s.prototype.events={"click #pace-dropdown a":"changePace"},s.prototype.initialize=function(){return this.listenTo(this.model,"change",this.render)},s.prototype.changePace=function(e){return this.model.set("pace",t(e.target).data("pace")),this.render(),!1},s.prototype.onDomRefresh=function(){return t(".dropdown-toggle",this.el).dropdown()},s.prototype.templateHelpers=function(){var t=this;return{totalDistance:function(){var e;return(e=t.model.get("total_distance"))?e>1e3?""+Math.round(e/100)/10+" km":""+Math.round(e)+" m":void 0},startAddress:function(e){var r;return null==e&&(e=!1),r=t.model.waypoints.first(),e?r.streetName():r.get("a")},finishAddress:function(e){var r;return null==e&&(e=!1),r=t.model.waypoints.last(),e?r.streetName():r.get("a")},description:function(){var e;return e=t.model.waypoints,e.size()>0?"<strong>"+e.first().streetName()+"</strong> to <strong>"+e.last().streetName()+"</strong>":void 0},paceDescription:function(){return r.str.titleize(t.model.get("pace"))},speedDescription:function(e){var o;return o=n.SPEEDS[t.model.get("mode")][e],""+r.str.titleize(e)+" pace - "+o+" km/hr"},formattedTime:function(){var e,r,o,n,i,s;return i=t.model.total_time(),r=Math.floor(i/60),e=1===r?"hour":"hours",n=Math.round(i-60*r),o=1===n?"minute":"minutes",s=""+n+" "+o,r>0&&(s=""+r+" "+e+", "+s),s}}},s}(o.CompositeView)})}.call(this);