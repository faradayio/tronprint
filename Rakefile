require 'bundler/setup'

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
