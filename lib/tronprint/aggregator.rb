require 'delegate'
require 'moneta'

module Tronprint
  class Aggregator < Delegator
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

    def __getobj__
      @delegate_sd_obj
    end
    def __setobj__(obj)
      @delegate_sd_obj = obj
    end

    def adapter_constant(adapter_underscored)
      if adapter_underscored == :pstore
        'PStore'
      elsif adapter_underscored == :yaml
        'YAML'
      else
        adapter_underscored.to_s.split('_').map(&:capitalize).join('')
      end
    end

    def update(key, value)
      old_value = self[key]
      new_value = old_value ? old_value + value : value
      self[key] = new_value
    end
  end
end
