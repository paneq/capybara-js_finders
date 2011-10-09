# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybara-js_finders/version"

Gem::Specification.new do |s|
  s.name        = "capybara-js_finders"
  s.version     = Capybara::JsFinders::VERSION
  s.authors     = ["Robert Pankowecki"]
  s.email       = %w(robert.pankowecki@gmail.com rpa@gavdi.com)
  s.homepage    = "https://github.com/paneq/capybara-js_finders"
  s.summary     = %q{Additional finders for capybara that for some reason cannot use only xpath for finding nodes but needs to execute js for some calculations}
  s.description = <<-DESC
    Additional finders for capybara that for some reason
    cannot use only xpath for finding nodes but needs to
    execute js for some calculations.

    Ex: I you want to find a table cell
    that is under or next to other cell the easiest way to do it is to
    check their position on page and compare them. This way you do not
    need to wory about calculating the effects of using colspan 
    and rowspan attributes.

    The downside is that you need to use capybara driver that runs
    a browser like selenium.
  DESC

  s.rubyforge_project = "capybara-js_finders"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "capybara", "~> 1.0"
  s.add_dependency "activesupport", "~> 3.0.10"

  s.add_development_dependency "rake", "~> 0.9.0"
  s.add_development_dependency "rdoc", ">= 2.4.2"
  s.add_development_dependency "sinatra", "~> 1.2.6"
  s.add_development_dependency "erubis", "~> 2.6.6"
  #s.add_development_dependency "bbq", "~> 0.0.3"
  s.add_development_dependency "redcarpet", "~> 1.17"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "i18n"
end
