# frozen_string_literal: true

module TestSupport
end

require_relative 'test_support/fake_element'
require_relative 'test_support/box'
require_relative 'test_support/label'

GlazeUI::ViewKit::Position.add_default(TestSupport::Box, :pack_start)

if ENV.fetch('USE_FAKE_ELEMENTS', 'false') == 'true'
  GUI_MODULE = TestSupport
  puts 'NOTE: the mode with fake elements activated'
else
  GUI_MODULE = Gtk
end
