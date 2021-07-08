# Facade class providing DSL to use the toolkit methods to define and build a form parts
# `render` method must be defined in child class to explain a form elements
module GlazeUI
  class BaseView < GLib::Object
    type_register

    def initialize
      super
      @view_buffer = ViewKit::ViewBuffer.new
    end

    def form
      @form || assemble_form
    end

    def refresh!(element_name)
      subview = @view_buffer.refresh_subview(element_name)
      ViewKit::FormBuilder.rebuild_subview(subview, @view_buffer)
      activate(element_name)

      # where should we call #show_all ???
      subview.element.show_all
      subview.element
    end

    # adapter method to initialize subview and to attach the one to a builder form buffer
    def add(element_or_klass, name_or_init_position = nil, init_position = nil, &block)
      subview = @view_buffer.attach_element(element_or_klass,
                                            name_or_init_position,
                                            init_position,
                                            &block)
      define_named_element(subview.element_name) if subview.element_name
    rescue StandardError => e
      # only when exception happened
      subview&.gtk_element&.destroy
      raise e
    end

    def position(pos_method, *pos_args)
      ViewKit::Position.new(pos_method, pos_args)
    end

    alias pos position

    # add Gtk::Box.new(:vertical) do |vbox|
    #   # set current element position by #place
    #   place :pack_start, expand: true, fill: true
    #
    #   # another elements position pick for each
    #   add Gtk::Button.new(label: "my_button"), pos(:pack_start, expand: true, fill: true)
    #   add Gtk::TextView do |section_text|
    #     place :pack_start, expand: true, fill: true
    #     # ...
    #   end
    # end
    def place(pos_method, *pos_args)
      # TODO: exception
      # unless rendering_stack[@current_rendering_level]&.place_position.nil?
      # raise ViewKit::PositionError, "double place error"
      @view_buffer.current_place_position = ViewKit::Position.new(pos_method, pos_args)
    end

    private

    def activate(element_name = nil)
      activating_controller_class = ACTIVATORS[self.class]
      if activating_controller_class
        activating_controller = activating_controller_class.new(self)
        activating_controller.activate(element_name)
      end
      true
    end

    def assemble_form
      render
      @form = ViewKit::FormBuilder.build_form(@view_buffer)
      activate
      @form
    end

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
