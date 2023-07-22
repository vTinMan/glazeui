
Experimental Ruby MVC framework for desktop applications compatible Windows and Linux using GTK+ (dependes on Gtk3).

At the moment the gem stays in development - you can install framework using manual building from sources:

    git clone <this_repo>
    cd glazeui
    gem build glazeui.gemspec
    gem install glazeui-0.0.0.gem

To create a project run

    glazeui create new_project_name

Run the following command for Windows cmd

    glazeui.bat create new_project_name

Go into new project folder and start application

    cd new_project_name
    ruby config/application.rb
