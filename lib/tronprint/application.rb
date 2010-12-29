require 'carbon'

module Tronprint
  class Application
    include Carbon

    emit_as :computation do
      provide :duration      # hours
      provide :zip_code
    end

    attr_accessor :duration, :zip_code, :name

    def initialize(attrs = {})
      attrs.each do |name, value|
        self.send("#{name}=", value)
      end
    end

    def name
      @name ||= File.basename(Dir.pwd)
    end
  end
end
