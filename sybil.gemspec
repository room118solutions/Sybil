# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sybil/version"

Gem::Specification.new do |s|
  s.name        = "sybil"
  s.version     = Sybil::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jim Ryan"]
  s.email       = ["jim@room118solutions.com"]
  s.homepage    = "http://github.com/room118solutions/sybil"
  s.summary     = %q{Easily switch between users during development of a Rails application}
  # s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "sybil"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
