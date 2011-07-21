module Tronprint

  # Tronprint::TrafficMonitor counts app requests
  class TrafficMonitor
    attr_accessor :aggregator, :application_name

    # Parameters:
    # +application_name+:: A unique application name.
    def initialize(application_name)
      self.application_name = application_name
    end

    def aggregator
      Tronprint.aggregator
    end

    # The key used to store number of requests in the Aggregator.
    def key
      [application_name, 'requests'].join('/')
    end

    # Increment the total number of requests
    def increment
      aggregator.update key, 1 if aggregator
    end

    def requests
      aggregator[key] || 0
    end
  end
end
