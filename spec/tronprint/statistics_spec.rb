require 'spec_helper'

describe Tronprint::Statistics do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }
  let(:cpu_monitor) { mock Tronprint::CPUMonitor, :total_recorded_cpu_time => 27.2,
                          :key => 'myapp' }
  let(:statistics) { Tronprint::Statistics.new aggregator, cpu_monitor }
  
  before do
    Tronprint.zip_code = 48915
    Tronprint.brighter_planet_key = 'ABC123'
    Tronprint.application_name = 'groove'
  end

  after do
    aggregator.clear
  end

  describe '#emission_estimate' do
    it 'sends uses total duration if no range is given' do
      statistics.stub!(:total_duration).and_return 28.7
      Tronprint::Application.should_receive(:new).
        with(:zip_code => 48915, :duration => 28.7, :brighter_planet_key => 'ABC123').
        and_return mock(Object, :emission_estimate => nil)
      statistics.emission_estimate
    end
    it 'sends a duration range if given' do
      statistics.stub!(:range_duration).and_return 18.7
      Tronprint::Application.should_receive(:new).
        with(:zip_code => 48915, :duration => 18.7, :brighter_planet_key => 'ABC123').
        and_return mock(Object, :emission_estimate => nil)
      statistics.emission_estimate(Time.now - 7200, Time.now)
    end
  end

  describe '#total_duration' do
    it 'looks up the total for the application and return number of hours' do
      mock_cpu = mock Tronprint::CPUMonitor, :key => 'groove/application/cpu_time'
      statistics.instance_variable_set :@cpu_monitor, mock_cpu
      statistics.aggregator.update 'groove/application/cpu_time', 5.0
      statistics.total_duration.should be_within(0.00001).of(0.00138)
    end
  end
end

