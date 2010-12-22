module Tronprint
  class CPUMonitor < Thread
    def initialize(options = {})
      options[:run] ||= true
      if options[:run]
        super() {}
      end
    end

    def key
      [Tronprint.application.name, 'application', 'cpu_time'].join('/')
    end

    def monitor
      Aggregator.update key, elapsed_cpu_time
      sleep 5  # take five, little thread
    end
  end
end
