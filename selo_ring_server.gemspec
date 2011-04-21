# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "selo_ring/version"

Gem::Specification.new do |s|
  s.name        = "selo_ring_server"
  s.version     = SeloRing::Server::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Selman ULUG"]
  s.email       = ["selman.ulug@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A Rinda::RingServer implementation with daemons}
  s.description = %q{A Rinda::RingServer implementation with daemons}

  s.add_dependency('thor', '~> 0.14')
  s.add_dependency('daemons', '~> 1.1')
  s.add_dependency('configuration', '~> 1.2')

  s.add_development_dependency("minitest")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
