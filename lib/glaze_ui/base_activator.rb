module GlazeUI
  module BaseActivator


    include Ready::Dependency
    alias :activate_view :dependency
    # DSL for activators


    def activate_delegators(*method_names)
      method_names.each do |method_name|
        module_eval <<-CODE
          def #{method_name}(*args,  &block)
            current_view.#{method_name}(*args, &block)
          end
        CODE
      end
    end


    def activation(*names, &block)
#       @_ui_activator = self
      # ???
      module_eval <<-CODE
        def activator
          #{self.to_s}
        end
        private :activator
      CODE

      @_ui_activations ||= {}
      # TODO !! names
      @_ui_activations[:default] = block
    end


    def included(base)
      # TODO registrate controller for views
      # TODO bad code
      base.class_eval <<-CODE
        extend Ready::Injection
        ready :current_view
      CODE
    end


  end
end
