# frozen_string_literal: true

module GlazeUI
  module BaseActivator
    def activate_view(view_class = nil, &block)
      raise ArgumentError if !block_given? && !(view_class < GlazeUI::BaseView)

      @activator_configured = false unless defined?(@activator_configured)
      @activated_view = block if block_given?
      @activated_view ||= view_class
      configure_activator
      @activated_view
    end

    def activated_view
      @activated_view
    end

    def ui_activations
      @ui_activations ||= {}
    end

    def activation(name = nil, &block)
      ui_activations[name] = block
    end

    def activation_defined?(name)
      ui_activations.key?(name)
    end

    def active_elements(*method_names)
      method_names.each do |method_name|
        module_eval(
          # def some_named_element(*args, &block)
          #   view.some_named_element(*args, &block)
          # end
          <<-RUBY, __FILE__, __LINE__ + 1
            def #{method_name}(*args, &block)
              view.#{method_name}(*args, &block)
            end
          RUBY
        )
      end
    end

    private

    def configure_activator
      return if @activator_configured

      @activator_configured = true
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        include ActivationKit::Activable

        ACTIVATOR_MODULE = self

        def activator
          ACTIVATOR_MODULE
        end
      RUBY
    end

    def included(controller)
      @activated_view.nil? and
        raise 'To use activator the activated view must be specified, e.g. `activate_view SomeView`'

      GlazeUI::ActivationKit::ACTIVATORS.add_activator(@activated_view, controller)
    end
  end
end
