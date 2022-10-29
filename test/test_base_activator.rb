# frozen_string_literal: true

require 'minitest_helper'

class TestBaseActivator < Minitest::Test
  def setup
    @view_class = Class.new(GlazeUI::BaseView)
    view_class = @view_class

    @activator = Module.new do
      extend GlazeUI::BaseActivator
      activate_view view_class
      activation(:hello)
      activation(:lets_go)
      activation(:allright)
    end
    activator = @activator

    @controller_class = Class.new do
      include activator
    end
  end

  def test_activator
    assert_equal(@controller_class, GlazeUI::ActivationKit::ACTIVATORS[@view_class])
    assert_equal(@activator, @controller_class.new.activator)
    assert_equal(%i[hello lets_go allright], @activator.ui_activations.keys)
  end
end
