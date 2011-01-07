require 'yaml'
require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'

module Tronprint
  extend self

  attr_accessor :aggregator_file_path, :zip_code, :application_name, :brighter_planet_key

  def aggregator_file_path
    @aggregator_file_path ||= config[:aggregator_file_path]
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

  def aggregator
    @aggregator ||= Aggregator.new :path => aggregator_file_path
  end

  def cpu_monitor
    @cpu_monitor ||= CPUMonitor.new aggregator, application_name
  end

  def application_name
    @application_name ||= File.basename(Dir.pwd)
  end

  def total_duration
    cpu_monitor.total_recorded_cpu_time
  end

  def footprint_amount
    app = Application.new :zip_code => zip_code, :duration => total_duration, 
      :brighter_planet_key => brighter_planet_key
    app.emission_estimate.to_f
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
      :aggregator_file_path => File.expand_path('tronprint.pstore', Dir.pwd)
    }
  end
end
