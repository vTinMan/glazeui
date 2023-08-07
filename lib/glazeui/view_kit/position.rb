# frozen_string_literal: true

module GlazeUI
  module ViewKit
    class Position
      class PositionError < StandardError; end

      attr_reader :pos_method, :pos_args

      def initialize(pos_method, pos_args = [])
        @pos_method = pos_method
        @pos_args = pos_args
      end

      def self.fetch_default(klass)
        defaults.fetch(klass)
      rescue KeyError
        raise PositionError,
              "default_position is not implemented for #{klass}. \
              Use #position or #place for define element position"
      end

      def self.defaults
        initialize_defaults
        @defaults
      end

      def self.add_default(klass, pos_method, pos_args = [])
        defaults[klass] = Position.new(pos_method, pos_args)
      end

      def self.initialize_defaults
        return if defined?(@default_initialized) && @default_initialized == true

        @default_initialized = true
        @defaults = {}
        return if ENV.fetch('USE_FAKE_ELEMENTS', 'false') == 'true'

        add_default(Gtk::Box, :pack_start, [expand: false, fill: false])
        add_default(Gtk::Fixed, :put, [0, 0])
        add_default(Gtk::ApplicationWindow, :add)
      end
    end
  end
end
