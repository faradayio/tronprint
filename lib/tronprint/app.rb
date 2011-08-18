require 'tronprint'

module Tronprint
  
  # App is a middleware that counts app requests
  class App
    def initialize(app)
      @app = app
    end

    def call(env)
      Tronprint.traffic_monitor.increment if Tronprint.connected?

      @app.call(env)
    end
  end
end
