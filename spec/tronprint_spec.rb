require 'spec_helper'

describe Tronprint do
  let(:mock_cpu) { mock Tronprint::CPUMonitor, :total_recorded_cpu_time => 27.2 }
  
  before do
    Tronprint.aggregator_options[:adapter] = :memory
  end

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

  describe '.emission_estimate' do
    it 'should send the zip code and total duration to the application' do
      Tronprint.instance_variable_set(:@emission_estimate, nil)
      Tronprint.zip_code = 48915
      Tronprint.brighter_planet_key = 'ABC123'
      Tronprint.stub!(:total_duration).and_return 28.7
      Tronprint::Application.should_receive(:new).
        with(:zip_code => 48915, :duration => 28.7, :brighter_planet_key => 'ABC123').
        and_return mock(Object, :emission_estimate => nil)
      Tronprint.emission_estimate
    end
  end

  describe '.brighter_planet_key' do
    it 'should return the brighter_planet_key config option' do
      Tronprint.instance_variable_set :@brighter_planet_key, nil
      Tronprint.stub!(:config).and_return({ :brighter_planet_key => 'aaa' })
      Tronprint.brighter_planet_key.should == 'aaa'
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
    before :each do
      Tronprint.instance_variable_set :@default_config, nil
    end
    after :each do
      ENV['TRONPRINT_API_KEY'] = nil
      ENV['MONGOHQ_URL'] = nil
    end
    it 'should return a default configuration' do
      Tronprint.default_config.should be_an_instance_of(Hash)
    end
    it 'should set the brighter_planet_key if ENV["TRONPRINT_API_KEY"] is set' do
      ENV['TRONPRINT_API_KEY'] = 'abc123'
      Tronprint.default_config[:brighter_planet_key].should == 'abc123'
    end
    it 'should use MongoHQ if ENV["MONGOHQ_URL"] is set' do
      ENV['MONGOHQ_URL'] = 'mongodb://foo.com/bar'
      Tronprint.default_config[:aggregator_options][:adapter].should == :mongodb
      Tronprint.default_config[:aggregator_options][:url].should == 'mongodb://foo.com/bar'
    end
  end

  describe '.total_duration' do
    it 'should look up the total for the application and return number of hours' do
      mock_cpu = mock Tronprint::CPUMonitor, :key => 'groove/application/cpu_time'
      Tronprint.instance_variable_set :@cpu_monitor, mock_cpu
      Tronprint.application_name = 'groove'
      Tronprint.aggregator.update 'groove/application/cpu_time', 5.0
      Tronprint.total_duration.should be_within(0.00001).of(0.00138)
    end
  end
end
