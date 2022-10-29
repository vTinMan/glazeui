# frozen_string_literal: true

# Facade class providing DSL to use the toolkit methods to define and build a form parts.
# `render` method should be defined in child class to explain a form elements.
module GlazeUI
  class BaseView < GLib::Object
    type_register

    attr_reader :view_buffer

    def initialize
      super
      @view_buffer = ViewKit::ViewBuffer.new
    end

    def form
      return @form if defined? @form

      render
      @form = ViewKit::FormBuilder.build_form(@view_buffer)
      ActivationKit::Initializer.new(self).call
      @form
    end

    def refresh!(element_name)
      subview = @view_buffer.refresh_subview(element_name)
      ViewKit::FormBuilder.rebuild_subview(subview, @view_buffer)
      ActivationKit::Initializer.new(self).call(subview)
      subview.element.show_all
      subview.element
    end

    # method #add - adapter method to initialize subview and to attach the one to view buffer
    #
    # arguments:
    # 1. element to add or element class to create instance and to add
    # 2. name
    #   - may be skipped
    # 3. position
    #   - may be skipped if default position is defined for class of parent element
    #   - or if the added element is root
    #
    # Examples
    #
    #     # element itself
    #     add Gtk::Fixed
    #
    #     add Gtk::Fixed.new
    #
    #     add Gtk::Fixed.new do |fixed|
    #       # setting and content...
    #     end
    #
    #
    #     # with position
    #     add Gtk::Button.new(label: "my_button"), pos(:put, 10, 10)
    #
    #     add Gtk::TextView, pos(:put, 10, 10) do |button|
    #       # setting and content...
    #     end
    #
    #
    #     # with name
    #     add Gtk::Button.new(label: "my_button"), :my_button
    #
    #     add Gtk::TextView, :text_section do |text_section|
    #       # "setting and content..."
    #     end
    #
    #
    #     # with name and position
    #     add Gtk::Button.new(label: "my_button"), :my_fixed, pos(:put, 10, 10)
    #
    #     add Gtk::TextView, :text_section, pos(:put, 10, 10) do |text_section|
    #       # setting and content...
    #     end
    def add(element_or_klass, name_or_init_position = nil, init_position = nil, &block)
      subview = @view_buffer.attach_element(element_or_klass,
                                            name_or_init_position,
                                            init_position,
                                            &block)
      define_named_element(subview.name) if subview.name
      subview.element
    rescue StandardError => e
      subview&.gtk_element&.destroy
      raise e
    end

    # example
    #     add Gtk::Box.new(:vertical) do |vbox|
    #       # set current element position by #place
    #       place :pack_start, expand: true, fill: true
    #
    #       # another elements position pick for each
    #       add Gtk::Button.new(label: "my_button"), pos(:pack_start, expand: true, fill: true)
    #       add Gtk::TextView do |section_text|
    #         place :pack_start, expand: true, fill: true
    #         # ...
    #       end
    #     end
    def position(pos_method, *pos_args)
      ViewKit::Position.new(pos_method, pos_args)
    end

    alias pos position

    def place(pos_method, *pos_args)
      # TODO: delegate method to @view_buffer
      @view_buffer.current_place_position = ViewKit::Position.new(pos_method, pos_args)
      # TODO: warning
      # unless rendering_stack[@current_rendering_level]&.place_position.nil?
      #   puts "WARNING: double place error"
    end

    private

    # element naming
    def define_named_element(name)
      return if respond_to? name

      singleton_class.class_eval(
        <<-CODE, __FILE__, __LINE__ + 1
          # def my_gui_element(*args, *block)
          #   @view_buffer['my_gui_element'].element
          # end

          def #{name}
            @view_buffer['#{name}'].element
          end
        CODE
      )
    end
  end
end
