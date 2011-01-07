require 'carbon'

module Tronprint
  class Application
    include Carbon

    emit_as :computation do
      provide :duration    # hours
      provide :zip_code
    end

    attr_accessor :duration, :zip_code

    def initialize(attrs = {})
      attrs.each do |name, value|
        self.send("#{name}=", value)
      end
    end
  end
end
