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

        return unless last_subview

        position = subview.init_position ||
                  subview.place_position ||
                  default_position

        last_subview.gtk_element.public_send(position.pos_method,
                                            subview.gtk_element,
                                            *position.pos_args)

        # activate(subview.element)
      end

      # def activate(view_element)
      #   # TODO: refresh, skip if view_element activated already
      #   return unless ACTIVATORS[view_element.class]
      #   activating_controller =
      #     ACTIVATORS[view_element.class].new(view_element)
      #   activating_controller.activate
      # end

      # default placement setting for some element classes
      def default_position
        parent_element = last_subview.gtk_element
        return if parent_element.nil?

        case parent_element
        when Gtk::Box
          Position.new :pack_start, [expand: false, fill: false]
        when Gtk::Fixed
          Position.new :put, [0, 0]
        when Gtk::ApplicationWindow
          Position.new :add
        # TODO: other container elements
        # when Gtk::TreeView
        #   pos :attach, 0, 1, 0, 1
        else
          raise PositionError,
                "default_position is not implemented for #{parent_element.class}. \
                Use #position or #place for define element position"
        end
      end
    end
  end
end