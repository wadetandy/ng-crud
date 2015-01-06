//= require jquery/dist/jquery
//= require bootstrap-sass-official/assets/javascripts/bootstrap-sprockets
//= require angular/angular
//= require angular-route/angular-route
//= require angular-resource/angular-resource
//
//  Inject templates directly into the $templateCache
//= require angular-rails-templates
//= require_tree ./templates

angular.module('ngCrud', ['ng', 'ngResource', 'ngRoute', 'ngCrud.Templates'])
