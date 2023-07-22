# frozen_string_literal: true

module GlazeUI
  class Application
    attr_reader :gtk_app,
                :main_view,
                :configuration,
                :main_application_view

    def initialize
      @configuration = GlazeUI::ApplicationConfig.new(self)
    end

    def configurate
      yield(@configuration) if block_given?
      @gtk_app = Gtk::Application.new(@configuration.application_name, @configuration.flags)
      @main_application_view = GlazeUI::MainWindowView.new(@configuration)
      @main_view = @configuration.main_view_class.new if @configuration.main_view_class
    end

    def run
      @gtk_app.signal_connect('activate') do
        @main_application_view.form.show
      end
      @gtk_app.run
    end

    def quit
      @main_application_view.destroy
    end
  end
end
