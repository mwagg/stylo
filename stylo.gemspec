# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "stylo/version"

Gem::Specification.new do |s|
  s.name        = "stylo"
  s.version     = Stylo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Wagg"]
  s.email       = ["michael@guerillatactics.co.uk"]
  s.homepage    = "http://rubygems.org/gems/stylo" # CHECK THIS
  s.summary     = %q{A javascript and css combining/minifying rack middleware}
  s.description = %q{A rack middleware which does css and javascript combining
                      and minification for sites hosted in readonly filesystem environments
                      such as heroku.com}

  s.rubyforge_project = "stylo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
