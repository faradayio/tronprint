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

  private

    def current_year
      Time.now.year.to_s
    end
    def current_month
      sprintf('%02d', Time.now.month)
    end
    def current_day
      sprintf('%02d', Time.now.day)
    end
    def current_hour
      sprintf('%02d', Time.now.hour)
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

    def update_hourly(key, value)
      update_entry path(key, 'by_date', current_year, current_month,
                        current_day, current_hour),
                   value
      update_entry path(key, 'hourly', current_hour), value
    end

    def update_entry(key, value)
      old_value = self[key]
      new_value = old_value ? old_value + value : value
      self[key] = new_value
    end
  end
end
