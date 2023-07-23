# frozen_string_literal: true

require 'minitest_helper'

class TestInitializer < Minitest::Test
  def setup
    @activation_queue = []
    setup_view_class
    setup_activator_module
    @view = @view_class.new
    @view.render
    @initializer = GlazeUI::ActivationKit::Initializer.new(@view)
  end

  def setup_view_class
    @view_class = Class.new(GlazeUI::BaseView) do
      def render
        add GUI_MODULE::Box.new(:vertical), :hello do
          add GUI_MODULE::Box.new(:vertical) do
            add GUI_MODULE::Box.new(:vertical), :lets_go do
              add GUI_MODULE::Box.new(:vertical), :allright
            end
          end
          add GUI_MODULE::Box.new(:vertical), :one_more
        end
      end
    end
  end

  def setup_activator_module
    view_class = @view_class
    activation_queue = @activation_queue

    activator = Module.new do
      extend GlazeUI::BaseActivator
      activate_view view_class
      activation { activation_queue << :default }
      activation(:hello) { activation_queue << :hello }
      activation(:lets_go) { activation_queue << :lets_go }
      activation(:allright) { activation_queue << :allright }
      activation(:one_more) { activation_queue << :one_more }
    end

    Class.new(GlazeUI::BaseController) { include activator }
  end

  def test_activation_order
    @initializer.call

    assert_equal(%i[default hello lets_go allright one_more], @activation_queue)
  end

  def test_partial_activation
    @initializer.call(@view.view_buffer[:hello])

    assert_equal(%i[hello lets_go allright one_more], @activation_queue)
    @activation_queue.clear
    @initializer.call(@view.view_buffer[:lets_go])

    assert_equal(%i[lets_go allright], @activation_queue)
  end
end
