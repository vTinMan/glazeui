module GlazeUI
  class BaseController

    # TODO
    # attr_reader :form

#     def initialize(form)
#       @form = form
#     end


    def form
      unless defined? current_view
        # TODO warning...
        puts "WARNING ..."
        return nil
      end
      
      activate
      puts "\n get form from #{self}"
      current_view.source
    end

  private

    def activate
      _ui_activations = activator.instance_variable_get(:@_ui_activations)
      puts "\n\n _ui_activations"
      p _ui_activations
      puts "\n\n"
      self.instance_eval &_ui_activations[:default]
#       _ui_activationss = self.class.ancestors.map {|it| it.instance_variable_get(:@_ui_activations) if it.is_a?(GlazeUI::BaseActivator) }.reject(&:nil?)
#       _ui_activationss.each do |_ui_activations|
#         self.instance_eval &_ui_activations[:default]
#       end
    end

  end
end
