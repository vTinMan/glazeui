module GlazeUI
  module ViewKit
    class Subview
      attr_accessor :place_position

      attr_reader :element_name,
                  :element,
                  :gtk_element,
                  :init_position,
                  :content_block,
                  :subviews

      def self.create(element_or_klass, name_or_init_position, init_position, &block)
        element = element_or_klass.new if element_or_klass.is_a?(Class)
        element ||= element_or_klass
        gtk_element = element.form if element.is_a?(BaseView)
        gtk_element ||= element

        init_position = name_or_init_position if name_or_init_position.is_a?(Position)
        init_position ||= init_position
        name = name_or_init_position unless name_or_init_position.is_a?(Position)

        new(element, gtk_element, name, init_position, &block)
      end

      def initialize(element, gtk_element, name, init_position, &block)
        @subviews = []
        @element = element
        @gtk_element = gtk_element
        @element_name = name
        @init_position = init_position
        @content_block = block
      end

      def <<(subview)
        @subviews << subview
      end

      def reset_subviews!
        @element.children.each { |child| @element.remove(child) }
        @subviews = []
      end
    end
  end
end
