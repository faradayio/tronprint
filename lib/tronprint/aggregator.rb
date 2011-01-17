require 'delegate'
require 'moneta'

module Tronprint

  # Tronprint::Aggregator stores aggregate application statistics 
  # to some sort of persistent key/value store. By default, this 
  # is a YAML file, but any key/value store supported by 
  # {moneta}[http://github.com/wycats/moneta] will work.
  class Aggregator < Delegator

    # Initialize the Aggregator with the following options:
    # +adapter+:: The underscore-ized name of the moneta class to use.
    # 
    # All other options are passed to the moneta adapter. 
    # You'll have to read {moneda's source code}[https://github.com/wycats/moneta/tree/master/lib/moneta/adapters]
    # for options needed by your desired adapter.
    def initialize(options = {})
      adapter_underscored = options.delete :adapter
      adapter_underscored ||= :pstore
      begin
        require "moneta/#{adapter_underscored.downcase}"
        klass = Moneta.const_get adapter_constant(adapter_underscored)
      rescue LoadError # Bundler hack
        require "moneta/adapters/#{adapter_underscored.downcase}"
        klass = Moneta::Adapters.const_get adapter_constant(adapter_underscored)
      end
      args = adapter_underscored == :memory ? [] : [options]
      super klass.new(*args)
    end

    def __getobj__ # :nodoc:
      @delegate_sd_obj
    end
    def __setobj__(obj) # :nodoc:
      @delegate_sd_obj = obj
    end

    # The class name of the desired moneta adapter
    def adapter_constant(adapter_underscored)
      if adapter_underscored == :pstore
        'PStore'
      elsif adapter_underscored == :yaml
        'YAML'
      else
        adapter_underscored.to_s.split('_').map(&:capitalize).join('')
      end
    end

    # Increment the total statistic by the given +value+, 
    # specified by the given +key+.
    def update(key, value)
      old_value = self[key]
      new_value = old_value ? old_value + value : value
      self[key] = new_value
    end
  end
end
