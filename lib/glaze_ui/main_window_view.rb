module GlazeUI
  class MainWindowView < BaseView
    attr_reader :app, :content_type, :config, :form

    def initialize(config)
      @config = config
      @glaze_app = config.glaze_app
      @gtk_app = @glaze_app.gtk_app
    end

    def render
      @form ||= @config.main_window_form if @config.main_window_form
      @form ||= create_default_gtk_form
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
      default_form.add main_view.form if main_view

      if @glaze_app.main_controller
        main_controller = @glaze_app.main_controller.new(main_view)
        main_controller.activate
      end
      default_form
    end
  end
end
