module GlazeUI
  class MainWindowView
    attr_reader :app, :content_type, :app_configuration, :form

    def initialize(app_configuration)
      @app_configuration = app_configuration
      @glaze_app = app_configuration.glaze_app
      @gtk_app = @glaze_app.gtk_app
    end

    def render
      if @app_configuration.main_window_form
        @form = @app_configuration.main_window_form
      else
        @form = Gtk::ApplicationWindow.new(@gtk_app)
        @form.set_default_size(*(@app_configuration.default_window_size || GlazeUI::ApplicationConfig::DEFAULT_WINDOW_SIZE))
        @form.set_title(@app_configuration.application_name) if @app_configuration.application_name
        @form.add @app_configuration.main_controller_class.new.form if @app_configuration.main_controller_class
        @form
      end
    end
  end
end
