# frozen_string_literal: true

require 'minitest_helper'

class TestPool < Minitest::Test
  def setup
    @view_class1 = Class.new
    @view_class2 = Class.new
    @view_class3 = Class.new
    @controller_class1 = Class.new
    @controller_class2 = Class.new
  end

  def test_add_activator
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class1, @controller_class1)
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class2, @controller_class2)

    assert_equal(2, GlazeUI::ActivationKit::ACTIVATORS.activators.length)
    assert_includes(GlazeUI::ActivationKit::ACTIVATORS.activators.to_a,
                    [@view_class1, @controller_class1])
    assert_includes(GlazeUI::ActivationKit::ACTIVATORS.activators.to_a,
                    [@view_class2, @controller_class2])
  end

  def test_defined_for
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class1, @controller_class1)
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class2, @controller_class2)

    assert(GlazeUI::ActivationKit::ACTIVATORS.defined_for?(@view_class1))
    assert(GlazeUI::ActivationKit::ACTIVATORS.defined_for?(@view_class2))
    refute(GlazeUI::ActivationKit::ACTIVATORS.defined_for?(@view_class3))
  end

  def test_getter
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class1, @controller_class1)
    GlazeUI::ActivationKit::ACTIVATORS.add_activator(@view_class2, @controller_class2)

    assert_equal(@controller_class1, GlazeUI::ActivationKit::ACTIVATORS[@view_class1])
    assert_equal(@controller_class2, GlazeUI::ActivationKit::ACTIVATORS[@view_class2])
    assert_nil GlazeUI::ActivationKit::ACTIVATORS[@view_class3]
  end

  def test_empty_list
    assert_instance_of(GlazeUI::ActivationKit::Pool, GlazeUI::ActivationKit::ACTIVATORS)
    assert_empty GlazeUI::ActivationKit::ACTIVATORS.activators
  end
end
