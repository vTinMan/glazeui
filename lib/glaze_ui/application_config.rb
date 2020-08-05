module GlazeUI
  class ApplicationConfig
    DEFAULT_WINDOW_SIZE = [1280, 640]
    # TODO add more configurations for Gtk::Application
    # TODO add documentation for config items
    attr_reader :glaze_app

    attr_accessor :application_name

    attr_accessor :main_controller_class

    attr_accessor :flags

    attr_accessor :default_window_size

    attr_accessor :main_window_form

    def initialize(glaze_app)
      @glaze_app = glaze_app
      @flags = :flags_none
      @application_name = "GlazeUI.app"
    end
  end
end
