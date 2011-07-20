module Tronprint

  # Tronprint::CPUMonitor is a thread that monitors aggregate CPU usage.
  class CPUMonitor < Thread
    attr_accessor :total_recorded_cpu_time, :application_name

    # Parameters:
    # +application_name+:: A unique application name.
    # +options+:: Extra options, such as:
    # --+run+:: Whether to fork the thread and run continuously. +true+ by default.
    def initialize(application_name, options = {})
      self.application_name = application_name
      options[:run] = true if options[:run].nil?
      if options[:run]
        super &thread_loop
      else
        super() {}  # Ruby 1.8 hack
      end
    end

    def thread_loop
      lambda do
        while(true) do
         monitor
         sleep(5)
        end
      end
    end

    # The key used to store CPU data in the Aggregator.
    def key
      [application_name, 'application', 'cpu_time'].join('/')
    end

    def aggregator
      Tronprint.aggregator
    end

    # The process used to collect CPU uptime data and store it.
    def monitor
      elapsed_time = elapsed_cpu_time
      aggregator.update key, elapsed_time
      self.total_recorded_cpu_time += elapsed_time
    end

    # The total amount of CPU time used by the current process 
    # since the time the process started.
    def total_cpu_time
      Process.times.inject(0) { |sum, i| sum += i }
    end

    # The total amount of CPU time we've recorded for the application.
    def total_recorded_cpu_time
      @total_recorded_cpu_time ||= 0.0
    end

    # The amount of CPU time consumed since the last time we checked.
    def elapsed_cpu_time
      total_cpu_time - total_recorded_cpu_time
    end
  end
end
