module GlazeUI
  class BaseController

    # TODO: change term
    attr_reader :current_view

    def initialize(current_view)
      @current_view = current_view
    end

    def form
      current_view.form
    end

    def activate(part = nil)
      part ||= :default
      return if activator.nil? || activator.ui_activations[part].nil?

      puts "\n\n activator.ui_activations"
      p activator.ui_activations
      puts "\n\n"
      instance_eval &activator.ui_activations[part]
      # if it.is_a?(GlazeUI::BaseActivator) }.reject(&:nil?)
      # _ui_activationss =
      #   self.class.ancestors
      #             .map { |it| it.instance_variable_get(:@_ui_activations)
      # _ui_activationss.each do |_ui_activations|
      # self.instance_eval &_ui_activations[:default]
      # end
    end
  end
end
