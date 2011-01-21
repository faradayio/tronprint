require 'rubygems'
require 'bundler'
Bundler.setup

begin
  require 'bueller'
  Bueller::Tasks.new
rescue LoadError
  puts "Bueller (or a dependency) not available. Install it with: gem install bueller"
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

  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tronprint #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
