require.config({
    paths: {
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap',
        underscore: '../components/underscore/underscore',
        backbone: '../components/backbone/backbone',
        marionette: '../components/backbone.marionette/lib/backbone.marionette',
        d3: "../components/d3/d3",
        r2d3: "../components/r2d3/r2d3",
        jquery_bbq: "vendor/jquery.bbq",
        search_widget: "search_widget"
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        },
        underscore:{
            exports: '_'
        },
        d3:{
          exports: "d3"
        },
        backbone:{
            deps:['jquery','underscore'],
            exports: "Backbone"
        },
        marionette:{
            deps: ["jquery","underscore","backbone"],
            exports: "Marionette"
        },
        jquery_bbq:{
          deps:["jquery"]
        }
    }
});

var d3lib = (Modernizr.svg) ? "d3" : "r2d3";


require(['marionette', "jquery_bbq", 'bootstrap', 'search_widget', d3lib], function () {
  'use strict';
  require(['app']);
});
