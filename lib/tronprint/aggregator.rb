require 'delegate'
require 'moneta'

module Tronprint

  # Tronprint::Aggregator stores aggregate application statistics 
  # to some sort of persistent key/value store. By default, this 
  # is a YAML file, but any key/value store supported by 
  # {moneta}[http://github.com/wycats/moneta] will work.
  class Aggregator < Delegator

    attr_accessor :adapter

    # Initialize the Aggregator with the following options:
    # +adapter+:: The underscore-ized name of the moneta class to use.
    # 
    # All other options are passed to the moneta adapter. 
    # You'll have to read {moneda's source code}[https://github.com/wycats/moneta/tree/master/lib/moneta/adapters]
    # for options needed by your desired adapter.
    def initialize(options = {})
      self.adapter = options.delete :adapter
      self.adapter ||= 'pstore'
      self.adapter = self.adapter.to_s.downcase

      options = process_options(options)

      begin
        require "moneta/#{self.adapter}"
        klass = Moneta.const_get adapter_constant
      rescue LoadError # Bundler hack
        require "moneta/adapters/#{self.adapter}"
        klass = Moneta::Adapters.const_get adapter_constant
      end
      args = self.adapter == 'memory' ? [] : [options]
      instance = klass.new(*args)
      __setobj__ instance  # required in Ruby 1.8.7
      super instance
    end

    # Handle initializer options for some special cases
    def process_options(options)
      if adapter == 'mongodb'
        options[:pool_size] = 3
      end
      options
    end

    def __getobj__ # :nodoc:
      @delegate_sd_obj
    end
    def __setobj__(obj) # :nodoc:
      @delegate_sd_obj = obj
    end

    # The class name of the desired moneta adapter
    def adapter_constant
      case self.adapter
      when 'pstore' then 'PStore'
      when 'yaml' then 'YAML'
      when 'mongodb' then 'MongoDB'
      else
        self.adapter.split('_').map(&:capitalize).join('')
      end
    end

    # Increment the total statistic by the given +value+, 
    # specified by the given +key+.
    def update(key, value)
      update_total(key, value)
      update_yearly(key, value)
      update_monthly(key, value)
      update_daily(key, value)
      update_hourly(key, value)
    end

    def path(*args)
      args.join('/')
    end

    def range_total(key, from, to)
      raise "Invalid range" if from > to
      total = 0
      current = from
      while current <= to
        hourly_key = hourly_path(key, year(current), month(current), day(current), hour(current))
        total += self[hourly_key].to_f
        current = current + 3600
      end

      total
    end

  private

    def year(time)
      time.year.to_s
    end
    def current_year
      year(Time.now)
    end
    def month(time)
      sprintf('%02d', time.month)
    end
    def current_month
      month(Time.now)
    end
    def day(time)
      sprintf('%02d', time.day)
    end
    def current_day
      day(Time.now)
    end
    def hour(time)
      sprintf('%02d', time.hour)
    end
    def current_hour
      hour(Time.now)
    end

    def update_total(key, value)
      update_entry key, value
    end

    def update_yearly(key, value)
      update_entry path(key, 'by_date', current_year), value
    end

    def update_monthly(key, value)
      update_entry path(key, 'by_date', current_year, current_month), value
    end

    def update_daily(key, value)
      update_entry path(key, 'by_date', current_year, current_month, current_day), value
    end

    def hourly_path(key, year, month, day, hour)
      path(key, 'by_date', year, month, day, hour)
    end
    def update_hourly(key, value)
      update_entry hourly_path(key, current_year, current_month,
                        current_day, current_hour),
                   value
      update_entry path(key, 'hourly', current_hour), value
    end

    def update_entry(key, value)
      begin
        old_value = self[key]
      rescue => e
        backtrace = ([e] + e.backtrace).join("\n")
        Tronprint.log_error "Tronprint: Unable to fetch statistics from datastore: #{backtrace}"
      end

      new_value = old_value ? old_value + value : value
      Tronprint.log_debug "Tronprint.aggregator[#{key.inspect}] = #{new_value}"

      begin
        self[key] = new_value
      rescue => e
        backtrace = ([e] + e.backtrace).join("\n")
        Tronprint.log_error "Tronprint: Unable to update datastore with statistics: #{backtrace}"
      end
    end
  end
end
