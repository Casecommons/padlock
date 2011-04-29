# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "padlock"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima, Brandon Keene & Todd Persen"]
  s.email = %q{casecommons-dev@googlegroups.com}
  s.homepage = %q{http://github.com/CaseCommons/padlock}
  s.summary = %q{Padlock is an environment-based component switch system.}

  s.add_development_dependency('rspec', '>= 2.1')
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]
end

