
Experimental Ruby MVC framework for desktop applications compatible with Windows and Linux using GTK+ (depends on [Gtk3](https://rubygems.org/gems/gtk3))

At the moment the gem stays in development - framework can be installed from sources using manual building:

    git clone git@github.com:vTinMan/glazeui.git
    cd glazeui
    gem build glazeui.gemspec
    gem install glazeui-0.0.0.gem

Or via Bundler

    gem 'glazeui', git: 'https://github.com/vTinMan/glazeui'

To create new project run

    glazeui create new_project_name

Run the following command for Windows cmd

    glazeui.bat create new_project_name

Go into new project folder and start application

    cd new_project_name
    ruby config/application.rb

#### Features

##### Base classes for Controllers and Views

The framework provides the classes underlying controllers and views

##### View DSL

Simple DSL to describe the structure of a form content compatible with [Gtk3 gem](https://rubygems.org/gems/gtk3)

##### Activators

Ruby-style approach based on modules to connect view events and controller methods

##### Refreshing

The framework provides the way to re-render view (fully or partially) without reinitialization via `refresh!` method

#### Demo

Demo project is available [here](https://github.com/vTinMan/glazeui_demo)
