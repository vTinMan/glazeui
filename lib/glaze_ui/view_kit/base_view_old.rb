module GlazeUI
  class BaseView
    Position = Struct.new(:pos_method, :pos_args)
    class PositionError < StandardError; end

    attr_reader :source, :named_elements_h, :rendering_stack

    def initialize
      super
      @named_elements_h = Hash.new {|_,v| [v] }
      @rendering_stack = []
      @current_rendering_level = -1
    end

    def form
      return @source if defined? @source
      render
      @source
    end

    def render
      # TODO: default render ?
      # Gtk::Box.new(:vertical)
      # render multiple souce !!!
      raise "not implemented"
    end

    def refresh(element_name)
      # TODO: error texts
      raise unless named_elements_h.key?(element_name)
      element = named_elements_h[element_name]
      raise unless element
      element.children.each { |child| element.remove(child) }
    end

    #
    # method #add - element addition
    #
    # if element is first then addition as @source (without placement/position)
    # if element isn't first then addition to parent element
    #     in a position which said in arguments or default (if it exist)
    #
    # block - a doing for element setting and it content placement
    #
    # with 1 argument
    # 1. a element itself for addition or it class for a instance initialize and addition
    #
    # with 3 argument
    # 1. -- same --
    # 2. a value (string, symbol, etc) for get element by name later
    # 3. a struct of GlazeUI::BaseView::Position with method and args for element placement to parent
    #
    # with 2 argument
    # 1. -- same --
    # 2. name or position (depending on the type)
    #
    # examples
    #
    #
    # add Gtk::Fixed
    #
    # add Gtk::Fixed.new
    #
    # add Gtk::Fixed.new do |fixed|
    #   # setting and content...
    # end
    #
    #
    # add Gtk::Button.new(label: "my_button"), pos(:put, 10, 10)
    #
    # add Gtk::TextView, pos(:put, 10, 10) do |button|
    #   # setting and content...
    # end
    #
    #
    # add Gtk::Button.new(label: "my_button"), :my_button
    #
    # add Gtk::TextView, :text_section do |text_section|
    #   # "setting and content..."
    # end
    #
    #
    # add Gtk::Button.new(label: "my_button"), :my_fixed, pos(:put, 10, 10)
    #
    # add Gtk::TextView, :text_section, pos(:put, 10, 10) do |text_section|
    #   # setting and content...
    # end
    #
    def add(element_or_klass, name_or_position = nil, _pos = nil, &block)
      # view_step = ViewRenderingStep.new(element_or_klass, name_or_position, _pos)
      # start new elements level
      @current_rendering_level += 1

      init_position = name_or_position.is_a?(GlazeUI::BaseView::Position) ? name_or_position : _pos
      view_step_factory = ViewStepFactory.new(element_or_klass, init_position, rendering_stack[@current_rendering_level-1]&.element)
      rendering_step = view_step_factory.make_step
      rendering_stack[@current_rendering_level] = rendering_step

      # set current element as source if it first
      if @current_rendering_level == 0
        # deny reset @source
        raise "deny reset root element" if @source
        @source = rendering_step.gtk_element
      end

      try_to_set_name(name_or_position.is_a?(GlazeUI::BaseView::Position) ? nil : name_or_position, rendering_step.element)

      # setting and content for current element
      yield(rendering_step.gtk_element) if block_given?
      rendering_step.activating_controller&.activate

      if @current_rendering_level > 0
        current_position = rendering_step.init_position || rendering_step.place_position || default_position(rendering_step.parent_element)
        rendering_stack[@current_rendering_level-1].element.public_send(current_position.pos_method, rendering_step.gtk_element, *current_position.pos_args)
      elsif rendering_step.init_position || rendering_step.place_position
        puts "WARNING: position is not able to apply for source element"
      end

    rescue StandardError => e
      rendering_step&.gtk_element&.destroy
      raise e
    ensure
      # clear & finish element stack level
      rendering_stack[@current_rendering_level] = nil if rendering_stack[@current_rendering_level]
      @current_rendering_level -= 1 if @current_rendering_level >= 0
    end

    def position(pos_method, *pos_args)
      Position.new(pos_method, pos_args)
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
      raise PositionError, "double place error" unless rendering_stack[@current_rendering_level]&.place_position.nil?
      rendering_stack[@current_rendering_level].place_position = Position.new(pos_method, pos_args)
    end

  private

    # element naming
    def try_to_set_name(name, element)
      return if name.nil?

      named_elements_h[name.to_s] = element
      # puts "\n\n\n\n named element <<<<<<<<<"
      # p name.to_s
      # p element
      unless respond_to? name
        self.singleton_class.class_eval <<-CODE
          def #{name}
            named_elements_h["#{name.to_s}"]
          end
        CODE
      end
      # TODO: save block if element is named
      # named_elements_h[name] = GlazeUI::BaseView::ElementView.new(element, block) unless name.nil?
    end

    # default placement setting for some elements
    def default_position(parent_element)
      return if parent_element.nil?

      case parent_element
      when Gtk::Box
        pos :pack_start, :expand => false, :fill => false
      when Gtk::Fixed
        pos :put, 0, 0
      when Gtk::ApplicationWindow
        pos :add
      # TODO: other container elements
      # when Gtk::TreeView
      #   pos :attach, 0, 1, 0, 1
      else
        raise GlazeUI::BaseView::PositionError, "default_position is not implemented for #{parent_element.class}. Use #position or #place for define element position"
      end
    end
  end
end
