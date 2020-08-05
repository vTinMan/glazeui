module GlazeUI
  class Application

    attr_reader :gtk_app, :main_controller, :configuration, :main_application_view

    def initialize
      @configuration = GlazeUI::ApplicationConfig.new(self)
    end

    def configurate(&block)
      yield(@configuration) if block_given?
      @gtk_app = Gtk::Application.new(@configuration.application_name, @configuration.flags)
      @main_application_view = GlazeUI::MainWindowView.new(@configuration)
      @main_controller = @configuration.main_controller_class.new if @configuration.main_controller_class
    end

    # class ApplicationConfigError < StandardError; end
    def run
      # raise ApplicationConfigError.new('Configure your main controller class before running application') if @main_controller.nil?
      @gtk_app.signal_connect("activate") { @main_application_view.render.show_all }
      @gtk_app.run
    end
  end
end
