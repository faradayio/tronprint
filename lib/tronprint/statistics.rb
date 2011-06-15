module Tronprint
  # The Statistics class is your gateway to fetching statistics about 
  # the energy usage and footprint of your app.
  class Statistics

    attr_accessor :aggregator, :cpu_monitor

    def initialize(aggregator, cpu_monitor)
      self.aggregator = aggregator
      self.cpu_monitor = cpu_monitor
    end

    # Fetch the total amount of CPU time (in hours) used by the application.
    def total_duration
      aggregator[cpu_monitor.key] / 3600
    end

    # Fetch total CPU time for a given range
    def range_duration(from, to)
      aggregator.range_total cpu_monitor.key, from, to
    end

    # Calculate emissions using aggregated data. A call is made to 
    # Brighter Planet's CM1 emission estimate service. Specifically,
    # the call is made to the {computation emitter}[http://carbon.brighterplanet.com/models/computation]
    def emission_estimate(from = nil, to = nil)
      duration = from.nil? ? total_duration : range_duration(from, to)

      app = Application.new :zip_code => Tronprint.zip_code, :duration => duration, 
        :brighter_planet_key => Tronprint.brighter_planet_key
      app.emission_estimate
    end

    # The total amount of CO2e generated by the application.
    def total_footprint
      emission_estimate.to_f
    end

    # The total amount of electricity used by the application.
    def total_electricity
      emission_estimate.electricity_use.to_f
    end
    
    # A URL for the methodology statement of the total_footprint calculation.
    def total_footprint_methodology
      emission_estimate.methodology
    end
  end
end
