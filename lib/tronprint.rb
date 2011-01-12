require 'yaml'
require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'

if defined?(Rails)
  require 'tronprint/rails'
end

module Tronprint
  extend self

  attr_accessor :aggregator_options, :zip_code, :application_name, :brighter_planet_key

  def aggregator_options
    @aggregator_options ||= config[:aggregator_options]
  end

  def zip_code
    @zip_code ||= config[:zip_code]
  end

  def brighter_planet_key
    @brighter_planet_key ||= config[:brighter_planet_key]
  end

  def run
    cpu_monitor
  end

  def running?
    !@cpu_monitor.nil?
  end

  def aggregator
    @aggregator ||= Aggregator.new aggregator_options
  end

  def cpu_monitor
    @cpu_monitor ||= CPUMonitor.new aggregator, application_name
  end

  def application_name
    @application_name ||= config[:application_name]
  end

  def total_duration
    aggregator[cpu_monitor.key]
  end

  def config
    load_config || default_config
  end

  def load_config
    return @loaded_config unless @loaded_config.nil?
    path = File.expand_path('config/tronprint.yml', Dir.pwd)
    @loaded_config = YAML::load_file path if File.exist? path
  end

  def default_config
    @default_config ||= {
      :aggregator_options => {
        :adapter => :YAML,
        :path => File.expand_path('tronprint_stats.yml', Dir.pwd)
      },
      :application_name => File.basename(Dir.pwd)
    }
  end

  def emission_estimate
    app = Application.new :zip_code => zip_code, :duration => total_duration, 
      :brighter_planet_key => brighter_planet_key
    app.emission_estimate
  end
end
