module Tronprint

  # Tronprint::CPUMonitor is a thread that monitors aggregate CPU usage.
  class TrafficMonitor
    attr_accessor :aggregator, :application_name, :requests

    # Parameters:
    # +aggregator+:: A Tronprint::Aggregator instance.
    # +application_name+:: A unique application name.
    def initialize(aggregator, application_name)
      self.aggregator = aggregator
      self.application_name = application_name
      self.requests = aggregator[key]
    end

    # The key used to store number of requests in the Aggregator.
    def key
      [application_name, 'requests'].join('/')
    end

    # Increment the total number of requests
    def increment
      self.requests += 1
      aggregator.update key, 1
    end

    def requests
      @requests ||= aggregator[key]
      @requests ||= 0
    end
  end
end
