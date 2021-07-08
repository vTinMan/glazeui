require 'glaze_ui'
require 'minitest/autorun'

class TestViewBuffer < Minitest::Test
  def setup
    @view_buffer = GlazeUI::ViewBuffer.new
  end

  def test_elaborate
    gtk_element = Gtk::Box.new(:vertical)
    subview = GlazeUI::Subview.new(gtk_element, gtk_element, nil, nil, &->(_) { })
    @view_buffer.send(:elaborate, subview)
    assert_nil @view_buffer.send(:last_subview)
  end

  def test_attach_element
    gtk_element = Gtk::Box.new(:vertical)
    @view_buffer.attach_element(gtk_element, nil, nil)
    assert_equal @view_buffer.instance_variable_get(:@subview_stack), []
    assert_equal @view_buffer.initial_subview.element, gtk_element
  end

  def test_attach_element_2
    gtk_element = Gtk::Box.new(:vertical)
    gtk_element_2 = Gtk::Box.new(:vertical)
    @view_buffer.attach_element(gtk_element, nil, nil) do
      @view_buffer.attach_element(gtk_element_2, nil, nil)
    end
    assert_equal @view_buffer.instance_variable_get(:@subview_stack), []
    assert_equal @view_buffer.initial_subview.element, gtk_element
    assert_equal @view_buffer.initial_subview.subviews.map(&:element), [gtk_element_2]
  end
end
