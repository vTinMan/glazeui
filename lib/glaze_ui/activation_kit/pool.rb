# frozen_string_literal: true

module GlazeUI
  module ActivationKit
    class Pool
      attr_reader :activators

      def initialize
        @activators = {}
      end

      def add_activator(view_to_activate, controller)
        @activators[view_to_activate] = controller
      end

      def [](activated_view)
        @activators[activated_view]
      end

      def defined_for?(activated_view)
        @activators.key?(activated_view)
      end
    end

    ACTIVATORS = Pool.new
  end
end
