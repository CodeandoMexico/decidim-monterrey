# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/ine/version"

Gem::Specification.new do |s|
  s.version = Decidim::Ine.version
  s.authors = ["Oscar Hernandez"]
  s.email = ["2067516+oxcar@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/codeandomexico/decidim-monterrey/decidim-module-ine"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-ine"
  s.summary = "A decidim ine module"
  s.description = "INE document verification."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Ine.version
  s.add_dependency "decidim-verifications", Decidim::Ine.version
end
