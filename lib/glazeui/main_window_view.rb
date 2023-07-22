# frozen_string_literal: true

module GlazeUI
  class MainWindowView < BaseView
    attr_reader :app, :content_type, :config

    def initialize(config)
      super()
      @config = config
      @glaze_app = config.glaze_app
      @gtk_app = @glaze_app.gtk_app
    end

    def form
      @form ||= render
    end

    def render
      return @config.main_window_form if @config.main_window_form

      create_default_gtk_form
    end

    def destroy
      @form&.destroy
    end

    private

    def create_default_gtk_form
      default_form = Gtk::ApplicationWindow.new(@gtk_app)
      form_size = @config.default_window_size
      form_size ||= GlazeUI::ApplicationConfig::DEFAULT_WINDOW_SIZE
      default_form.set_default_size(*form_size)
      default_form.set_title(@config.application_name) if @config.application_name
      main_view = @config.main_view_class.new if @config.main_view_class
      if main_view
        default_form.add main_view.form
        main_view.form.show
      end
      default_form
    end
  end
end
