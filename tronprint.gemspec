# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'tronprint/version'

Gem::Specification.new do |s|
  s.name = 'tronprint'
  s.version = Tronprint::VERSION

  s.authors = ['Derek Kastner']
  s.date = "2011-06-22"
  s.description = %q{A gem for monitoring the carbon footprint of your ruby app}
  s.email = %q{dkastner@gmail.com}
  s.homepage = %q{http://github.com/brighterplanet/tronprint}

  s.files = Dir.glob('lib/**/*.rb') + [
    '.document',
    '.rspec',
    'Gemfile',
    'Rakefile',
    'tronprint.gemspec',
    'autotest/discover.rb'
  ]
  s.test_files = Dir.glob('spec/**/*') + Dir.glob('features/**/*')
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc'
  ]

  s.require_paths = ['lib']
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby process carbon footprinter}

  s.add_development_dependency 'actionpack', '~> 3'
  s.add_development_dependency 'activesupport', '~> 3'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'bueller', '~> 0.0.2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'sandbox'
  s.add_development_dependency 'timecop'
  s.add_runtime_dependency   'carbon', '~> 1.1.1'
  s.add_runtime_dependency 'i18n'
  s.add_runtime_dependency 'dkastner-moneta', '~> 1.1.0'
end

