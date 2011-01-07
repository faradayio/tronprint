require 'spec_helper'

describe Tronprint do
  let(:mock_cpu) { mock Tronprint::CPUMonitor, :total_recorded_cpu_time => 27.2 }
  describe '.run' do
    it 'should start up each monitor' do
      Tronprint.should_receive :cpu_monitor
      Tronprint.run
    end
  end

  describe '.cpu_monitor' do
    it 'should start the CPU monitor' do
      Tronprint::CPUMonitor.should_receive(:new).and_return mock_cpu
      Tronprint.cpu_monitor
    end
    it 'should return the CPU monitor instance' do
      Tronprint.instance_variable_set :@cpu_monitor, nil
      Tronprint::CPUMonitor.stub!(:new).and_return mock_cpu
      Tronprint.cpu_monitor.should == mock_cpu
    end
  end

  describe '.footprint_amount' do
    let(:estimate) { mock Object, :to_f => 100.1 }
    let(:mock_application) { mock Tronprint::Application, :emission_estimate => estimate }

    it 'should return the total footprint of the application' do
      Tronprint.stub!(:total_duration).and_return 28.7
      Tronprint::Application.stub!(:new).and_return mock_application
      Tronprint.footprint_amount.should == 100.1
    end
    it 'should send the zip code and total duration to the application' do
      Tronprint.zip_code = 48915
      Tronprint.stub!(:total_duration).and_return 28.7
      Tronprint::Application.should_receive(:new).
        with(:zip_code => 48915, :duration => 28.7).
        and_return mock_application
      Tronprint.footprint_amount
    end
  end
end
