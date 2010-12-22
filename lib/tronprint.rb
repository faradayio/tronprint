require 'tronprint/aggregator'
require 'tronprint/application'
require 'tronprint/cpu_monitor'

module Tronprint
  extend self

  def run
    cpu_monitor
  end

  def cpu_monitor
    @cpu_monitor ||= CPUMonitor.new
  end

  def application
    @application ||= Application.new
  end

  def total_footprint
    application.emissions
  end
end
