require 'carbon'

module Tronprint
  class Application
    include Carbon

    emit_as :computation do
      provide :duration    # hours
      provide :zip_code
    end

    attr_accessor :duration, :zip_code, :brighter_planet_key

    def initialize(attrs = {})
      attrs.each do |name, value|
        self.send("#{name}=", value)
      end
    end

    def emission_estimate(options = {})
      super options.merge(:key => brighter_planet_key)
    end
  end
end
