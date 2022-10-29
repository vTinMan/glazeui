# frozen_string_literal: true

require 'minitest_helper'

class TestBaseView < Minitest::Test
  def setup
    test_view_class = Class.new(GlazeUI::BaseView) do
      def render
        add Gtk::Box.new(:vertical) do
          add Gtk::Label.new('my_label')
        end
      end
    end
    @view = test_view_class.new
  end

  def test_form
    assert_instance_of(Gtk::Box, @view.form)
    assert_equal(1, @view.form.children.length)
    assert_instance_of(Gtk::Label, @view.form.children.first)
  end
end
