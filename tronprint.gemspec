# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tronprint}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Derek Kastner"]
  s.date = %q{2011-01-12}
  s.description = 'A gem for monitoring the carbon footprint of your ruby app'
  s.email = %q{dkastner@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "autotest/discover.rb",
    "features/step_definitions/tronprint_steps.rb",
    "features/support/env.rb",
    "features/tronprint.feature",
    "lib/tronprint.rb",
    "lib/tronprint/aggregator.rb",
    "lib/tronprint/application.rb",
    "lib/tronprint/cpu_monitor.rb",
    "lib/tronprint/rails.rb",
    "lib/tronprint/rails/generator.rb",
    "lib/tronprint/rails/tronprint_helper.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/tronprint/aggregator_spec.rb",
    "spec/tronprint/application_spec.rb",
    "spec/tronprint/computer_spec.rb",
    "spec/tronprint/cpu_monitor_spec.rb",
    "spec/tronprint/rails/tronprint_helper_spec.rb",
    "spec/tronprint_spec.rb",
    "tronprint.gemspec"
  ]
  s.homepage = %q{http://github.com/dkastner/tronprint}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = 'Ruby process carbon footprinter'
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/tronprint/aggregator_spec.rb",
    "spec/tronprint/application_spec.rb",
    "spec/tronprint/computer_spec.rb",
    "spec/tronprint/cpu_monitor_spec.rb",
    "spec/tronprint/rails/tronprint_helper_spec.rb",
    "spec/tronprint_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<sandbox>, [">= 0"])
      s.add_runtime_dependency(%q<carbon>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<moneta>, [">= 0"])
    else
      s.add_dependency(%q<carbon>, ["~> 1.0.3"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_dependency(%q<moneta>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<sandbox>, [">= 0"])
    end
  else
    s.add_dependency(%q<carbon>, ["~> 1.0.3"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
    s.add_dependency(%q<moneta>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<sandbox>, [">= 0"])
  end
end

