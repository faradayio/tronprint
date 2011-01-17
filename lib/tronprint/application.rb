require 'carbon'

module Tronprint

  # Tronprint::Application is the class responsible for 
  # obtaining emission estimates from CM1.
  class Application
    include Carbon

    emit_as :computation do
      provide :duration    # hours
      provide :zip_code
    end

    attr_accessor :duration, :zip_code, :brighter_planet_key

    # Initialize using Rails' model initializer style.
    #
    #   Tronprint::Application.new :duration => 3.0
    def initialize(attrs = {})
      attrs.each do |name, value|
        self.send("#{name}=", value)
      end
    end

    # The options accepted are those accepted by 
    # {Carbon::EmissionEstimate}[http://rdoc.info/github/brighterplanet/carbon/master/Carbon#emission_estimate-instance_method]
    def emission_estimate(options = {})
      super options.merge(:key => brighter_planet_key)
    end
  end
end
