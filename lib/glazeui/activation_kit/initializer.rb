# frozen_string_literal: true

module GlazeUI
  module ActivationKit
    class Initializer
      def initialize(view_to_activate)
        @view_to_activate = view_to_activate
        @initial_subview = view_to_activate.view_buffer.initial_subview
      end

      def call(subview = nil)
        return false unless activator_defined?

        activate_default if subview.nil?
        activate(subview || @initial_subview)
        true
      end

      private

      def activate_default
        controller.activate(nil) if activator.activation_defined?(nil)
      end

      # recursive method
      def activate(subview)
        subview.name && activator.activation_defined?(subview.name) &&
          controller.activate(subview.name)

        subview.subviews.each do |child_subview|
          activate(child_subview) if child_subview.name || child_subview.subviews.length.positive?
        end
      end

      def activator_defined?
        ActivationKit::ACTIVATORS.defined_for?(@view_to_activate.class)
      end

      def controller
        return @controller if defined? @controller

        controller_class = ActivationKit::ACTIVATORS[@view_to_activate.class]
        @controller = controller_class.new(@view_to_activate)
      end

      def activator
        controller.activator
      end
    end
  end
end
