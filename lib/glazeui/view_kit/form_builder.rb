# frozen_string_literal: true

module GlazeUI
  module ViewKit
    class FormBuilder
      def self.build_form(buffer)
        new(buffer).build_form
      end

      def self.rebuild_subview(subview, buffer)
        new(buffer, subview).build_form
      end

      def initialize(view_buffer, start_subview = nil)
        @view_buffer = view_buffer
        @subview_stack = []
        @start_subview = start_subview || @view_buffer.initial_subview
      end

      def build_form
        make_subform(@start_subview)
        @start_subview.gtk_element
      end

      private

      def last_subview
        @subview_stack.last
      end

      def make_subform(subview)
        @subview_stack.push subview
        subview.subviews.each do |child_subview|
          make_subform(child_subview)
        end
        @subview_stack.pop
        mount_subview(subview)
      end

      def mount_subview(subview)
        return unless last_subview

        position = subview.init_position ||
                   subview.place_position ||
                   default_position

        last_subview.content_element.public_send(position.pos_method,
                                                 subview.gtk_element,
                                                 *position.pos_args)
        subview.gtk_element.show unless subview.hidden
      end

      # default placement setting for some element classes
      def default_position
        parent_element = last_subview.content_element
        return if parent_element.nil?

        Position.fetch_default(parent_element.class)
      end
    end
  end
end
