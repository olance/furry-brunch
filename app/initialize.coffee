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
  MyApp.Views.AppView = new AppView = require 'views/app_view'

  # Initialize Backbone History
  Backbone.history.start pushState: yes
