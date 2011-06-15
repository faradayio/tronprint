namespace :tronprint do
  desc 'Manually set up ActiveRecord datastore for Tronprint'
  task :moneta => :environment do
    adapter_options = Tronprint.aggregator_options
    ar = Moneta::Adapters::ActiveRecord.new
    ar.migrate
    puts 'Ensured that Moneta::Adapters::ActiveRecord::Store exists'
  end
end
