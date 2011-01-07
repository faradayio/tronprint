require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'

module Tronprint
  extend self

  attr_accessor :aggregator_file_path, :zip_code, :application_name

  def run
    cpu_monitor
  end

  def aggregator_file_path
    @aggregator_file_path ||= File.expand_path('tronprint.pstore', Dir.pwd)
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
    app = Application.new :zip_code => zip_code, :duration => total_duration
    app.emission_estimate.to_f
  end
end
