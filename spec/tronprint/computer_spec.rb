require 'spec_helper'

describe Tronprint::Application do
  it 'should report emission esimates for application-related activity' do
    app = Tronprint::Application.new :duration => 72831, :zip_code => 48915
    app.should respond_to(:emission_estimate)
  end
end

