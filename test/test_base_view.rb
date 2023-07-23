# frozen_string_literal: true

require 'minitest_helper'

class TestBaseView < Minitest::Test
  def setup
    test_view_class = Class.new(GlazeUI::BaseView) do
      def render
        add GUI_MODULE::Box.new(:vertical) do
          add GUI_MODULE::Label
        end
      end
    end
    @view = test_view_class.new
  end

  def test_form
    assert_instance_of(GUI_MODULE::Box, @view.form)
    assert_equal(1, @view.form.children.length)
    assert_instance_of(GUI_MODULE::Label, @view.form.children.first)
  end
end
