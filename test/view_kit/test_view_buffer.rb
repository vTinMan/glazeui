# frozen_string_literal: true

require 'minitest_helper'

class TestViewBuffer < Minitest::Test
  def setup
    @view_buffer = GlazeUI::ViewKit::ViewBuffer.new
  end

  def test_attach_element
    gtk_element = GUI_MODULE::Box.new(:vertical)
    @view_buffer.attach_element(gtk_element, nil, nil)

    assert_nil @view_buffer.send(:last_subview)
    assert_empty(@view_buffer.instance_variable_get(:@subview_stack))
    assert_equal(gtk_element, @view_buffer.initial_subview.element)
  end

  def test_attach_element2
    gtk_element = GUI_MODULE::Box.new(:vertical)
    gtk_element2 = GUI_MODULE::Box.new(:vertical)
    @view_buffer.attach_element(gtk_element, nil, nil) do
      @view_buffer.attach_element(gtk_element2, nil, nil)
    end

    assert_nil @view_buffer.send(:last_subview)
    assert_empty(@view_buffer.instance_variable_get(:@subview_stack))
    assert_equal(gtk_element, @view_buffer.initial_subview.element)
    assert_equal([gtk_element2], @view_buffer.initial_subview.subviews.map(&:element))
  end
end
