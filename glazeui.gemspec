# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'glazeui'
  s.version = '0.0.0'
  s.licenses = ['MIT']
  s.summary = 'GlazeUI - GTK GUI Framework'
  s.description = 'GlazeUI Framework to develop GTK-applications'
  s.authors = ['vTinMan']
  s.email = 'tin.vsl@gmail.com'
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.bindir = 'bin'
  s.executables << 'glazeui'
  s.homepage = 'https://github.com/vTinMan/glazeui'
  # TODO: s.homepage = 'https://rubygems.org/gems/glazeui'
  s.metadata = { 'source_code_uri' => 'https://github.com/vTinMan/glazeui' }
  s.required_ruby_version = '>= 2.5.0'
  s.add_runtime_dependency 'gtk3', '~> 3.0', '>= 3.0.0'
end
