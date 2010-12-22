require 'spec_helper'

describe Tronprint do
  let(:mock_cpu) { mock Tronprint::CPUMonitor }
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

  describe '.total_footprint' do
    let(:mock_application) { mock Tronprint::Application }

    it 'should return the total footprint of the application' do
      mock_application.stub!(:emissions).and_return 100
      Tronprint.stub!(:application).and_return mock_application
      Tronprint.total_footprint.should == 100
    end
  end
end
