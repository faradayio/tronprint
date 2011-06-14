module Tronprint

  # Tronprint::CPUMonitor is a thread that monitors aggregate CPU usage.
  class TrafficMonitor
    attr_accessor :aggregator, :application_name

    # Parameters:
    # +aggregator+:: A Tronprint::Aggregator instance.
    # +application_name+:: A unique application name.
    def initialize(aggregator, application_name)
      self.aggregator = aggregator
      self.application_name = application_name
    end

    # The key used to store number of requests in the Aggregator.
    def key
      [application_name, 'requests'].join('/')
    end

    # Increment the total number of requests
    def increment
      aggregator.update key, 1
    end

    def requests
      aggregator[key] || 0
    end
  end
end
