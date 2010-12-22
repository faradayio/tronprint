require 'spec_helper'

describe Tronprint::CPUMonitor do
  let(:cpu_monitor) { Tronprint::CPUMonitor.new :run => false }
  describe 'monitor' do
    before :each do
      cpu_monitor.stub! :sleep
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 23.87
      Tronprint::Aggregator.stub!(:update)
    end
    it 'should write the elapsed time to the aggregate statistics' do
      Tronprint.application.name = 'my_app'
      Tronprint::Aggregator.should_receive(:update).
        with('my_app/application/cpu_time', 23.87)
      cpu_monitor.monitor
    end
    it 'should sleep when it is done' do
      cpu_monitor.should_receive :sleep
      cpu_monitor.monitor
    end
  end

  describe 'elapsed_cpu_time' do
    it 'should return the total CPU time on the first run'
    it 'should return the amount of CPU time used since the last check'
  end

  describe 'record_time' do
    it 'should update the total CPU time for the current application'
  end
end

