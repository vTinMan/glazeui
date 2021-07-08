module GlazeUI
  module BaseActivator
    def activate_view(view_class = nil, &block)
      raise ArgumentError if !block_given? && !(view_class < GlazeUI::BaseView)

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

    def activation(name = :default, &block)
      ui_activations[name] = block
    end

    def configure_activator
      return if @activator_configured

      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        ACTIVATOR_MODULE = self

        def activator
          ACTIVATOR_MODULE
        end
      RUBY

      # def current_view
      # return @current_view if defined? @current_view
      # @current_view = activator.activated_view.call if activator.activated_view.is_a?(Proc)
      # @current_view ||= activator.activated_view.new
      # @current_view
      # end
      # private :current_view
      @activator_configured = true
    end

    def included(controller)
      @activated_view.nil? and
        raise 'Required to specify activated view to use activator, e.g. `activate_view SomeView`'

      GlazeUI::ACTIVATORS.add_activator(@activated_view, controller)
    end

    def activate_delegators(*method_names)
      method_names.each do |method_name|
        module_eval(
          <<-RUBY, __FILE__, __LINE__ + 1
            # def some_view_element(*args, *block)
            #   current_view.some_view_element(*args, &block)
            # end

            def #{method_name}(*args,  &block)
              current_view.#{method_name}(*args, &block)
            end
          RUBY
        )
      end
    end
  end
end
