require 'rails'
require 'tronprint/rails/tronprint_helper'

module Tronprint

  # Rails plugin class.
  class Railtie < Rails::Railtie
    config.after_initialize do
      Tronprint.run # if Rails.env.production?
    end

    generators do
      require 'tronprint/rails/generator'
    end
  end
end
