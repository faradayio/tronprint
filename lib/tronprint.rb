require 'yaml'
require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'
require 'tronprint/traffic_monitor'
require 'tronprint/statistics'

if defined?(Rails) && Rails.const_defined?('Railtie')
  require 'tronprint/rails'
end

# Tronprint helps you visualize the carbon footprint of all of those little 
# Ruby processes zooming around on your system in their light cycles. You 
# can then show this footprint to the world of the Users via Rails helpers.
#
# The Tronprint module itself provides a method, .emission_estimate, that 
# will tell you the number of kilograms of CO2 (including the equivalent 
# amount of CO2 representing other greenhouse gasses) the current ruby 
# application is generating.
#
# The aggregate amount of CO2-generating activity is stored in a user-defined 
# key/value store that will keep track of emissions for any application 
# specified by Tronprint.application_name.
#
# == Getting Started
#
# See README.rdoc for more information.
module Tronprint
  extend self

  attr_accessor :aggregator_options, :zip_code, :application_name, :brighter_planet_key

  # Options to send the aggregator. See Tronprint::Aggregator.new
  def aggregator_options
    if @aggregator_options.nil?
      @aggregator_options = config[:aggregator_options]
      if env
        @aggregator_options = @aggregator_options[env]
        @aggregator_options ||= config[:aggregator_options] if config[:aggregator_options].keys.include?(:adapter)
        @aggregator_options ||= default_config[:aggregator_options]
      end
    end
    @aggregator_options
  end

  def env
    @env ||= if defined?(Rails)
      Rails.env.to_sym
    elsif ENV['RACK_ENV']
      ENV['RACK_ENV'].to_sym
    end
  end

  # The zip code of the server's hosting location. This affects 
  # the total footprint because certain regions rely more heavily
  # on different sources of electricity.
  def zip_code
    @zip_code ||= config[:zip_code]
  end

  # This is your Brighter Planet API key. Get one from 
  # {keys.brighterplanet.com}[http://keys.brighterplanet.com]
  def brighter_planet_key
    @brighter_planet_key ||= config[:brighter_planet_key]
  end

  # The name of your application (used to group aggregate data).
  def application_name
    @application_name ||= config[:application_name]
  end

  # Run the footprinter by starting up a background thread which 
  # collects data.
  def run
    cpu_monitor
  end

  # Check whether the data collection thread is running.
  def running?
    !@cpu_monitor.nil?
  end

  # The Tronprint::Aggregator instance.
  def aggregator
    @aggregator ||= Aggregator.new aggregator_options.dup
  end

  # The Tronprint::CPUMonitor instance.
  def cpu_monitor
    @cpu_monitor ||= CPUMonitor.new aggregator, application_name
  end

  # The Tronprint::TrafficMonitor instance
  def traffic_monitor
    @traffic_monitor ||= TrafficMonitor.new aggregator, application_name
  end

  # The Tronprint::Statistics interface
  def statistics
    @statistics ||= Statistics.new aggregator, cpu_monitor
  end

  # The current configuration.
  def config
    default_config.dup.update load_config
  end

  def config=(val)
    @loaded_config = val
    @default_config = val
  end

  # Fetch the configuration stored in config/tronprint.yml.
  def load_config
    return @loaded_config unless @loaded_config.nil?
    path = File.expand_path('config/tronprint.yml', Dir.pwd)
    @loaded_config = YAML::load_file path if File.exist? path
    @loaded_config ||= {}
  end

  # By default, the YAML adapter is used and aggregate statistics 
  # are stored in `pwd`/tronprint_stats.yml. The application name 
  # is assumed to be the name of the current directory.
  def default_config
    return @default_config unless @default_config.nil?
    @default_config = {
      :application_name => File.basename(Dir.pwd)
    }
    @default_config[:brighter_planet_key] = ENV['TRONPRINT_API_KEY'] if ENV['TRONPRINT_API_KEY']
    if ENV['MONGOHQ_URL']
      @default_config[:aggregator_options] = {
        :uri => ENV['MONGOHQ_URL'],
        :adapter => :mongodb,
        :collection => 'tronprint'
      }
    end
    @default_config[:aggregator_options] ||= {
      :adapter => :YAML,
      :path => File.expand_path('tronprint_stats.yml', Dir.pwd)
    }
    @default_config
  end
end
