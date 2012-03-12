require 'carbon'

module Tronprint

  # Tronprint::Application is the class responsible for 
  # obtaining emission estimates from CM1.
  class Application
    include Carbon

    emit_as 'Computation' do
      provide :duration    # seconds
      provide :zip_code
    end

    attr_reader :duration, :zip_code, :brighter_planet_key

    # Initialize using Rails' model initializer style.
    #
    #   Tronprint::Application.new :duration => 3.0
    def initialize(attrs = {})
      @duration = attrs[:duration]
      @zip_code = attrs[:zip_code]
      @brighter_planet_key = attrs[:brighter_planet_key]
    end

    # The options accepted are those accepted by 
    # {Carbon#impact method}[http://rdoc.info/github/brighterplanet/carbon/Carbon#impact-instance_method]
    def impact(options = {})
      if (response = impact(options.merge(:key => brighter_planet_key))).success
        response
      end
    end

    def emission_estimate(options = {})
      if response = impact(options)
        response.decisions.carbon.object.value
      end
    end
  end
end
