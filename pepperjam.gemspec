# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pepperjam/version"

Gem::Specification.new do |s|
  s.name        = "pepperjam"
  s.version     = Pepperjam::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Ehlert"]
  s.email       = ["ian.ehlert@tstmedia.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby gem to hit the PepperJam report api.}
  s.description = %q{Ruby gem to hit the PepperJam report api.}

  s.rubyforge_project = "pepperjam"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency(%q<httparty>)
  s.add_dependency(%q<fastercsv>)
end
