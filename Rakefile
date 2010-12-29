require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'tronprint'
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = 'dkastner@gmail.com'
    gem.homepage = 'http://github.com/dkastner/tronprint'
    gem.authors = ['Derek Kastner']
    gem.add_development_dependency 'cucumber'
    gem.add_development_dependency 'jeweler', '~> 1.4.0'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec', '~>2.0'
    gem.add_development_dependency 'sandbox'
    gem.add_dependency 'carbon', '~> 1.0.3'
    gem.add_dependency 'i18n'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:examples)

  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
  end
rescue LoadError
  puts 'RSpec tasks unavailable'
end

task :test => :examples
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tronprint #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
