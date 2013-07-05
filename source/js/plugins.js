//= require jquery/jquery
//= require underscore/underscore
//= require backbone/backbone
//= require backbone.marionette/lib/backbone.marionette
//= require d3/d3
//= require jquery.cookie/jquery.cookie
//= require underscore.string/lib/underscore.string
//= require vendor/bootstrap
//= require vendor/jquery.bbq
//= require_self


// Avoid `console` errors in browsers that lack a console.
if (!(window.console && console.log)) {
    (function() {
        var noop = function() {};
        var methods = ['assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error', 'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log', 'markTimeline', 'profile', 'profileEnd', 'markTimeline', 'table', 'time', 'timeEnd', 'timeStamp', 'trace', 'warn'];
        var length = methods.length;
        var console = window.console = {};
        while (length--) {
            console[methods[length]] = noop;
        }
    }());
}

// Mix in Underscore.string functions to Underscore
_.mixin(_.string.exports());
