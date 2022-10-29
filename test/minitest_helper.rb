# frozen_string_literal: true

require 'minitest/autorun'
require 'glaze_ui'

# rubocop:disable Style/GuardClause, Style/ClassAndModuleChildren
class Minitest::Test
  def before_setup
    super
    if GlazeUI.const_defined?('ActivationKit')
      GlazeUI.send(:remove_const, 'ActivationKit')
      Dir['lib/glaze_ui/activation_kit/*'].each { |f| load f }
    end
  end
end
# rubocop:enable Style/GuardClause, Style/ClassAndModuleChildren
