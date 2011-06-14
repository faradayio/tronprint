require 'rails'
require 'tronprint/rails/tronprint_helper'
require 'tronprint/app'

module Tronprint

  # Rails plugin class.
  class Railtie < Rails::Railtie
    initializer 'tronprint.configure' do |app|
      app.config.middleware.use Tronprint::App
    end

    config.after_initialize do
      Tronprint.run
    end

    generators do
      require 'tronprint/rails/generator'
    end
  end
end
