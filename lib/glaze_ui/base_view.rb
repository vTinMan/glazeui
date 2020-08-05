module GlazeUI
  class BaseView

    Position = Struct.new(:pos_method, :pos_args)

    ElementPosition = Struct.new(:element, :scope_position, :place_position)

#     ElementView = Struct.new(:form_element, :rendering)

    class PositionError < StandardError; end

    # TODO @source or @content
    # TODO position_stack
    attr_reader :source, :elements_h, :element_positions, :current_level



    def initialize
      @elements_h = Hash.new {|_,v| [v] }
      # init elements stack
      @element_positions = []
      @current_level = 0
      # TODO ??? when render?
      # render
    end



    def render
      # TODO default render ?
      # Gtk::Box.new(:vertical)
      # render multiple souce !!!
      raise "not implemented"
    end


    def refresh(element_name)
      # TODO error texts
      raise unless elements_h.key?(element_name)
      element = elements_h[element_name]
      raise unless element
      element.children.each {|child| element.remove(child) }
    end

  protected



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

      # start new elements level
      @current_level += 1

      # TODO for Class from views call Factory
      puts "check element_or_klass"
      if element_or_klass.is_a?(Class) && (element_or_klass <= GlazeUI::BaseView || element_or_klass <= GlazeUI::BaseController)
        puts "element_or_klass.is_a?(GlazeUI::BaseView)"
        element = element_or_klass.new.form
      elsif element_or_klass.is_a?(Class)
        puts "Class"
        element = element_or_klass.new
      elsif element_or_klass.is_a?(GlazeUI::BaseView) || element_or_klass.is_a?(GlazeUI::BaseController)
        puts "element_or_klass.is_a?(GlazeUI::BaseView)"
        element = element_or_klass.form
      else
        puts "element_or_klass"
        element = element_or_klass
      end
      puts "element"
      p element

      # set current element as source if it first
      if current_level == 1
        # deny reset @source
        raise "deny reset root element" if @source
        @source = element
      end

      # init elements stack item (combined with method #pos)
      element_positions[current_level] ||= ElementPosition.new
      element_positions[current_level].element = element
      puts "\n\n element_positions\n"
      p element_positions

      # element naming
      name = _pos || name_or_position.is_a?(GlazeUI::BaseView::Position) ? nil : name_or_position
      unless name.nil?
        elements_h[name.to_s] = element
        unless respond_to? name
          self.singleton_class.class_eval <<-CODE
            def #{name}
              elements_h["#{name.to_s}"]
            end
          CODE
        end
      end

      # TODO save block if element is named
      # elements_h[name] = GlazeUI::BaseView::ElementView.new(element, block) unless name.nil?

      # setting and content for current element
      puts "current_level: #{current_level}"
      yield(element) if block_given?

      # placement new element on level
      _position = name_or_position.is_a?(GlazeUI::BaseView::Position) ? name_or_position : _pos
      _position ||= element_positions[current_level].place_position
      _position ||= element_positions[current_level].scope_position
      if current_level > 1
        _position ||= default_position
        element_positions[current_level-1].element.public_send(_position.pos_method, element, *_position.pos_args)
      elsif _position
        puts "WARNING: position not applying for source element"
      end

#     ensure
      # clear element stack level data (combined with method #pos)
      puts "current_level: #{current_level}"
      element_positions[current_level].place_position = nil if element_positions[current_level].place_position
      element_positions[current_level].element = nil if element_positions[current_level].element

      # finish elements level
      @current_level -= 1 if current_level > 0
    end

    # ???
    def build
    end

    # pos :pack_start, expand: true, fill: true do
    #   add Gtk::Button.new(label: "my_button")
    #   add Gtk::TextView do |section_text|
    #     # ...
    #   end
    # end
    def position(pos_method, *pos_args, &block)
      _pos = Position.new(pos_method, pos_args)
      if block_given?
        element_positions[current_level+1] = _pos
        yield
      end
      _pos
    ensure
      element_positions[current_level+1].scope_position = nil if
          block_given? && element_positions[current_level+1].scope_position
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
      raise PositionError, "double place error" unless element_positions[current_level].place_position.nil?
      element_positions[current_level].place_position = Position.new(pos_method, pos_args)
    end


  private


    # default placement setting for some elements
    def default_position
      case element_positions[current_level-1].element
      when Gtk::Box
        pos :pack_start, :expand => false, :fill => false
      when Gtk::Fixed
        pos :put, 0, 0
      when Gtk::ApplicationWindow
        pos :add
      # TODO other container elements
      # when Gtk::TreeView
      #   pos :attach, 0, 1, 0, 1
      else
        raise PositionError, "default_position is not implemented for #{element_positions[current_level-1].element.class}. Use #position or #place for define element position"
      end
    end

  end
end
