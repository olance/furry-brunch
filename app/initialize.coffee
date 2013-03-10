# App Namespace
@MyApp ?= {}
MyApp.Routers ?= {}
MyApp.Views ?= {}
MyApp.Models ?= {}
MyApp.Collections ?= {}

$ ->
  # Load App Helpers
  require 'lib/app_helpers'

  # Initialize App
  AppView = require 'views/app_view'
  MyApp.Views.AppView = new AppView()

  # Initialize Backbone History
  Backbone.history.start pushState: yes
