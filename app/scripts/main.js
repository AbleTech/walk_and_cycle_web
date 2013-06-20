require.config({
    paths: {
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap',
        underscore: '../components/underscore/underscore',
        backbone: '../components/backbone/backbone',
        marionette: '../components/backbone.marionette/lib/backbone.marionette',
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
        backbone:{
            deps:['jquery','underscore'],
            exports: "Backbone"
        },
        marionette:{
            deps: ["jquery","underscore","backbone"],
            exports: "Marionette"
        }
    }
});

require(['jquery', 'bootstrap','underscore','backbone','marionette','search_widget'], function () {
    'use strict';
    require(['app']);
});
