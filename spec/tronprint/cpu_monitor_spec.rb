require 'spec_helper'

describe Tronprint::CPUMonitor do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }
  let(:cpu_monitor) { Tronprint::CPUMonitor.new aggregator, 'my_app', :run => false }

  describe '#monitor' do
    before :each do
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 23.87
    end
    it 'writes the elapsed time to the aggregate statistics' do
      cpu_monitor.monitor
      aggregator['my_app/application/cpu_time'].should == 23.87
    end
    it 'increments the toal recorded cpu time' do
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 9.0
      cpu_monitor.monitor
      cpu_monitor.total_recorded_cpu_time.should == 9.0
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 12.0
      cpu_monitor.monitor
      cpu_monitor.total_recorded_cpu_time.should == 21.0
    end
  end

  describe '#elapsed_cpu_time' do
    it 'returns the total CPU time on the first run' do
      cpu_monitor.stub!(:total_recorded_cpu_time).and_return 0
      cpu_monitor.stub!(:total_cpu_time).and_return 9.0
      cpu_monitor.elapsed_cpu_time.should == 9.0
    end
    it 'returns the amount of CPU time used since the last check' do
      cpu_monitor.stub!(:total_recorded_cpu_time).and_return 23.0
      cpu_monitor.stub!(:total_cpu_time).and_return 36.0
      cpu_monitor.elapsed_cpu_time.should == 13.0
    end
  end

  describe '#total_cpu_time' do
    it 'returns the total user and system time of the process' do
      Process.stub!(:times).and_return [10.1, 12.3]
      cpu_monitor.total_cpu_time.should == 22.4
    end
  end

  describe '#total_recorded_cpu_time' do
    it 'returns 0 by default' do
      cpu_monitor.total_recorded_cpu_time.should == 0
    end
    it 'returns total recorded time' do
      cpu_monitor.total_recorded_cpu_time = 3
      cpu_monitor.total_recorded_cpu_time.should == 3
    end
  end
end

