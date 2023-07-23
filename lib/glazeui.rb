# frozen_string_literal: true

require 'gtk3'

require_relative 'glazeui/base_view'
require_relative 'glazeui/base_controller'
require_relative 'glazeui/base_activator'
require_relative 'glazeui/main_window_view'
require_relative 'glazeui/application_config'
require_relative 'glazeui/application'
require_relative 'glazeui/activation_kit/activable'
require_relative 'glazeui/activation_kit/initializer'
require_relative 'glazeui/activation_kit/pool'
require_relative 'glazeui/view_kit/position'
require_relative 'glazeui/view_kit/view_buffer'
require_relative 'glazeui/view_kit/subview'
require_relative 'glazeui/view_kit/form_builder'

module GlazeUI
  VERSION = '0.0.0'
end
