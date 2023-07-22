# frozen_string_literal: true

module GlazeUI
  class ApplicationConfig
    DEFAULT_WINDOW_SIZE = [1280, 640].freeze

    # TODO: add more configurations for Gtk::Application
    # TODO: add documentation for config items
    attr_reader :glaze_app

    attr_accessor :application_name,
                  :main_view_class,
                  :flags,
                  :default_window_size,
                  :main_window_form

    def initialize(glaze_app)
      @glaze_app = glaze_app
      @flags = :flags_none
      @application_name = 'GlazeUI.app'
    end
  end
end
