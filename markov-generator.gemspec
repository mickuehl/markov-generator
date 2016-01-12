# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: markov-generator 0.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "markov-generator"
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Kuehl"]
  s.date = "2016-01-12"
  s.description = "A Markov Chain text generator library"
  s.email = "hello@ratchet.cc"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/markov.rb",
    "lib/markov/dictionary.rb",
    "lib/markov/generator.rb",
    "lib/markov/parser.rb",
    "lib/markov/token.rb",
    "lib/markov/util.rb",
    "markov-generator.gemspec",
    "test/generator_test.rb",
    "test/test_bulk_markov.rb",
    "test/test_markov.rb",
    "test/test_parser.rb",
    "test/texts/alice.txt",
    "test/texts/cthulhu.txt",
    "test/texts/grimm.txt"
  ]
  s.homepage = "http://github.com/ratchetcc/markov-generator"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Markov Chain text generator"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

