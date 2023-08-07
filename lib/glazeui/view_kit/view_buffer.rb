# frozen_string_literal: true

module GlazeUI
  module ViewKit
    class ViewBuffer
      attr_reader :initial_subview, :named_subviews

      def initialize
        @subview_stack = []
        @named_subviews = {}
      end

      def [](name)
        @named_subviews[name.to_s]
      end

      def attach_element(element_or_klass, name_or_init_position, init_position, &block)
        subview = Subview.create(element_or_klass,
                                 name_or_init_position,
                                 init_position,
                                 &block)
        add(subview)
        elaborate(subview) if subview.content_block
        save_named_subview(subview) if subview.name
        subview
      end

      def refresh_subview(name)
        subview = self[name]
        raise ArgumentError, 'element not found' if subview.nil?

        subview.reset_subviews!
        elaborate(subview) if subview.content_block
        subview
      end

      def current_place_position=(position)
        last_subview.place_position = position
      end

      def hide_current
        last_subview.hidden = true
      end

      private

      def add(subview)
        @initial_subview ||= subview
        return if @subview_stack.empty?

        last_subview << subview
      end

      def elaborate(subview)
        @subview_stack.push subview
        subview.content_block.call(subview.gtk_element)
      ensure
        @subview_stack.pop
      end

      def last_subview
        @subview_stack.last
      end

      def save_named_subview(subview)
        @named_subviews[subview.name.to_s] = subview
      end
    end
  end
end
