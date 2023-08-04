# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "omniauth/omniauth-idmty/version"

Gem::Specification.new do |spec|
  spec.add_dependency "omniauth", "~> 2"
  spec.add_dependency "openid_connect", "~> 2.2.0"
  # spec.add_dependency 'oauth2', '~> 2.0', '>= 2.0.9'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.name = "omniauth-idmty"
  spec.version = OmniAuth::IDMty::VERSION
  spec.authors = ["Ali González"]
  spec.email = ["ali@basicavisual.io"]
  spec.summary = "implements Monterrey OPEN-ID strategy"
  spec.description = "implements Monterrey OPEN-ID strategy for ID"
  spec.homepage = "https://github.com/CodeandoMexico/decidim-monterrey/omniauth-idmty"
  spec.license = "AGPL-3.0"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = "2.7.5"
  spec.files = Dir["lib/**/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
  spec.extra_rdoc_files = ["README.md"]
end
