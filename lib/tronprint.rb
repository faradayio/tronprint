require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'

module Tronprint
  extend self

  attr_accessor :aggregator_file_path

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
    @cpu_monitor ||= CPUMonitor.new aggregator
  end

  def application
    @application ||= Application.new
  end

  def footprint_amount
    application.emission_estimate.to_f
  end
end
