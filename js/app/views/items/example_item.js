!function(){var t={}.hasOwnProperty,e=function(e,o){function r(){this.constructor=e}for(var n in o)t.call(o,n)&&(e[n]=o[n]);return r.prototype=o.prototype,e.prototype=new r,e.__super__=o.prototype,e};define(["jquery","marionette"],function(t,o){var r,n;return r=function(o){function r(){return n=r.__super__.constructor.apply(this,arguments)}return e(r,o),r.prototype.tagName="li",r.prototype.template=JST["app/templates/example_item"],r.prototype.events={"click a.journey_name":"showExample",mouseover:"hoverEnter",mouseout:"hoverExit"},r.prototype.modelEvents={highlight:"highlight",unhighlight:"unhighlight"},r.prototype.hoverEnter=function(){return this.model.highlight()},r.prototype.hoverExit=function(){return this.model.unhighlight()},r.prototype.highlight=function(){return t(this.el).addClass("highlight")},r.prototype.unhighlight=function(){return t(this.el).removeClass("highlight")},r.prototype.showExample=function(t){return t.preventDefault(),this.model.showExample(),!1},r}(o.ItemView)})}.call(this);