require 'tronprint'

module Tronprint
  class App
    def initialize(app)
      @app = app
    end

    def call(env)
      Tronprint.traffic_monitor.increment

      @app.call(env)
    end
  end
end
