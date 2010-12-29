require 'yaml'

module Tronprint
  module Aggregator
    extend self

    attr_accessor :file_path, :data

    def file_path
      @file_path ||= File.join(Dir.pwd, 'tronprint.yml')
    end

    def data
      return {} unless File.exist?(file_path)
      saved_data = YAML::load_file(file_path)
      saved_data.respond_to?(:[]) ? saved_data : {}
    end

    def file
      @file ||= File.open(file_path, 'w')
    end

    def cached_data
      @cached_data ||= data
    end

    def clear_cache!
      @cached_data = nil
    end

    def read(key)
      cached_data[key]
    end

    def write(key, value)
      begin
        cached_data[key] = value
        file = File.open(file_path, 'w')
        file.flock File::LOCK_EX
        YAML::dump cached_data, file
      ensure
        file.flock File::LOCK_UN
        file.close
        clear_cache!
      end
      value
    end

    def update(key, value)
      old_value = read key
      new_value = old_value ? old_value + value : value
      write key, new_value
    end
  end
end
