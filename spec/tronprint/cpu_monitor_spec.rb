require 'spec_helper'

describe Tronprint::CPUMonitor do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }
  let(:cpu_monitor) { Tronprint::CPUMonitor.new aggregator, 'my_app', :run => false }

  describe '#monitor' do
    before :each do
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 23.87
    end
    it 'should write the elapsed time to the aggregate statistics' do
      cpu_monitor.monitor
      aggregator['my_app/application/cpu_time'].should == 23.87
    end
    it 'should increment the toal recorded cpu time' do
      aggregator[cpu_monitor.key] = nil
      cpu_monitor.instance_variable_set :@total_recorded_cpu_time, nil
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 9.0
      cpu_monitor.monitor
      cpu_monitor.total_recorded_cpu_time.should == 9.0
      cpu_monitor.stub!(:elapsed_cpu_time).and_return 12.0
      cpu_monitor.monitor
      cpu_monitor.total_recorded_cpu_time.should == 21.0
    end
  end

  describe '#elapsed_cpu_time' do
    it 'should return the total CPU time on the first run' do
      cpu_monitor.stub!(:total_recorded_cpu_time).and_return 0
      cpu_monitor.stub!(:total_cpu_time).and_return 9.0
      cpu_monitor.elapsed_cpu_time.should == 9.0
    end
    it 'should return the amount of CPU time used since the last check' do
      cpu_monitor.stub!(:total_recorded_cpu_time).and_return 23.0
      cpu_monitor.stub!(:total_cpu_time).and_return 36.0
      cpu_monitor.elapsed_cpu_time.should == 13.0
    end
    it 'should load recorded cpu time from previous runs when process is restarted' do
      cpu_monitor.instance_variable_set :@total_recorded_cpu_time, nil
      aggregator[cpu_monitor.key] = 12.5
      cpu_monitor.stub!(:total_cpu_time).and_return 36.0
      cpu_monitor.elapsed_cpu_time.should == 23.5
    end
  end

  describe '#total_cpu_time' do
    it 'should return the total user and system time of the process' do
      Process.stub!(:times).and_return [10.1, 12.3]
      cpu_monitor.total_cpu_time.should == 22.4
    end
  end

  describe '#total_recorded_cpu_time' do
    it 'should return nil by default' do
      cpu_monitor.total_recorded_cpu_time.should be_nil
    end
    it 'should return total recorded time' do
      cpu_monitor.total_recorded_cpu_time = 3
      cpu_monitor.total_recorded_cpu_time.should == 3
    end
    it 'should load previously recorded times from previous runs' do
      aggregator[cpu_monitor.key] = 12.4
      cpu_monitor.total_recorded_cpu_time.should == 12.4
    end
  end
end

