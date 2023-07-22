# frozen_string_literal: true

module GlazeUI
  module ViewKit
    class Subview
      attr_accessor :place_position,
                    :hidden

      attr_reader :name,
                  :element,
                  :gtk_element,
                  :content_element,
                  :init_position,
                  :content_block,
                  :subviews

      def self.create(element_or_klass, name_or_position, initial_position, &block)
        element = element_or_klass.is_a?(Class) ? element_or_klass.new : element_or_klass
        gtk_element = element.is_a?(BaseView) ? element.form : element
        content_element = element.is_a?(BaseView) ? element.content_element : element
        init_position = name_or_position.is_a?(Position) ? name_or_position : initial_position
        name = name_or_position unless name_or_position.is_a?(Position)
        new(element, gtk_element, content_element, name, init_position, &block)
      end

      def initialize(element, gtk_element, content_element, name, init_position, &block)
        @subviews = []
        @element = element
        @gtk_element = gtk_element
        @content_element = content_element
        @name = name
        @init_position = init_position
        @content_block = block
      end

      def <<(subview)
        @subviews << subview
        @subviews
      end

      def reset_subviews!
        @element.children.each { |child| @element.remove(child) }
        @subviews = []
        true
      end
    end
  end
end
