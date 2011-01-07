module Tronprint
  class CPUMonitor < Thread
    attr_accessor :total_recorded_cpu_time, :aggregator, :application_name

    def initialize(aggregator, application_name, options = {})
      self.aggregator = aggregator
      self.application_name = application_name
      options[:run] ||= true
      if options[:run]
        super do
          while(true) do
           monitor
           sleep(5)
          end
        end
      end
    end

    def key
      [application_name, 'application', 'cpu_time'].join('/')
    end

    def monitor
      elapsed_time = elapsed_cpu_time
      aggregator.update key, elapsed_time
      self.total_recorded_cpu_time += elapsed_time
    end

    def total_cpu_time
      Process.times.inject(0) { |sum, i| sum += i }
    end

    def total_recorded_cpu_time
      @total_recorded_cpu_time ||= 0.0
    end

    def elapsed_cpu_time
      total_cpu_time - total_recorded_cpu_time
    end
  end
end
