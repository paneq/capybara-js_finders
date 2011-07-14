# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybara-js_finders/version"

Gem::Specification.new do |s|
  s.name        = "capybara-js_finders"
  s.version     = Capybara::JsFinders::VERSION
  s.authors     = ["Robert Pankowecki (Gavdi)"]
  s.email       = ["rpa@gavdi.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "capybara-js_finders"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
