# frozen_string_literal: true

# module containing default activator module methods
# dedicated to include in activator child modules through configuration methods
module GlazeUI
  module ActivationKit
    module Activable
      def activate(part)
        return if activator.nil? || !activator.activation_defined?(part)

        instance_eval(&activator.ui_activations[part])
      end
    end
  end
end
