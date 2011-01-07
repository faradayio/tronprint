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
      Tronprint.brighter_planet_key = 'ABC123'
      Tronprint.stub!(:total_duration).and_return 28.7
      Tronprint::Application.should_receive(:new).
        with(:zip_code => 48915, :duration => 28.7, :brighter_planet_key => 'ABC123').
        and_return mock_application
      Tronprint.footprint_amount
    end
  end

  describe '.config' do
    it 'should return a configuration loaded from disk' do
      Tronprint.stub!(:load_config).and_return nil
      Tronprint.stub!(:default_config).and_return :foo => :bar
      Tronprint.config.should == { :foo => :bar }
    end
    it 'should return a default configuration if no config file exists' do
      Tronprint.stub!(:load_config).and_return :foo => :bar
      Tronprint.config.should == { :foo => :bar }
    end
  end

  describe '.load_config' do
    it 'should load a config file from cwd/config/tronprint.yml if it exists' do
      Dir.stub!(:pwd).and_return '/some/dir'
      File.stub!(:exist?).and_return true
      YAML.should_receive(:load_file).with('/some/dir/config/tronprint.yml').
        and_return :my => :config
      Tronprint.load_config.should == { :my => :config }
    end
    it 'should return nil if no config file exists' do
      Tronprint.instance_variable_set :@loaded_config, nil
      Dir.stub!(:pwd).and_return '/some/dir'
      File.stub!(:exist?).and_return false
      Tronprint.load_config.should be_nil
    end
  end

  describe '.default_config' do
    it 'should return a default configuration' do
      Tronprint.default_config.should be_an_instance_of(Hash)
    end
  end
end
