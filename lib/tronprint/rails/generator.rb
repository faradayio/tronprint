require 'rails/generators'

class TronprintGenerator < Rails::Generators::Base
  def create_config_file
    create_file 'config/tronprint.yml', Tronprint.config.to_yaml
  end
end
