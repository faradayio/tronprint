require 'spec_helper'

class Rails
  def self.env
    'development'
  end
end

describe Tronprint do
  let(:mock_cpu) { mock Tronprint::CPUMonitor, :total_recorded_cpu_time => 27.2 }

  describe '.run' do
    it 'starts up each monitor' do
      Tronprint.should_receive :cpu_monitor
      Tronprint.run
    end
  end

  describe '.cpu_monitor' do
    it 'starts the CPU monitor' do
      Tronprint.instance_variable_set :@cpu_monitor, nil
      Tronprint::CPUMonitor.should_receive(:new).and_return mock_cpu
      Tronprint.cpu_monitor
    end
    it 'returns the CPU monitor instance' do
      Tronprint.instance_variable_set :@cpu_monitor, nil
      Tronprint::CPUMonitor.stub!(:new).and_return mock_cpu
      Tronprint.cpu_monitor.should == mock_cpu
    end
  end

  describe '.brighter_planet_key' do
    it 'returns the brighter_planet_key config option' do
      Tronprint.instance_variable_set :@brighter_planet_key, nil
      Tronprint.stub!(:config).and_return({ :brighter_planet_key => 'aaa' })
      Tronprint.brighter_planet_key.should == 'aaa'
    end
  end

  describe '.config' do
    it 'returns a configuration loaded from disk' do
      Tronprint.stub!(:load_config).and_return :foo => :bar
      Tronprint.config.should include(:foo => :bar)
    end
    it 'returns a default configuration if no config file exists' do
      Tronprint.stub!(:default_config).and_return :foo => :bar
      Tronprint.config.should include(:foo => :bar)
    end
  end

  describe '.load_config' do
    before :each do
      Tronprint.instance_variable_set :@loaded_config, nil
    end
    it 'loads a config file from cwd/config/tronprint.yml if it exists' do
      Dir.stub!(:pwd).and_return '/some/dir'
      File.stub!(:exist?).and_return true
      YAML.should_receive(:load_file).with('/some/dir/config/tronprint.yml').
        and_return :my => :config
      Tronprint.load_config.should == { :my => :config }
    end
    it 'returns nil if no config file exists' do
      Tronprint.instance_variable_set :@loaded_config, nil
      Dir.stub!(:pwd).and_return '/some/dir'
      File.stub!(:exist?).and_return false
      Tronprint.load_config.should be_empty
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
    it 'returns a default configuration' do
      Tronprint.default_config.should be_an_instance_of(Hash)
    end
    it 'sets the brighter_planet_key if ENV["TRONPRINT_API_KEY"] is set' do
      ENV['TRONPRINT_API_KEY'] = 'abc123'
      Tronprint.default_config[:brighter_planet_key].should == 'abc123'
    end
    it 'uses MongoHQ if ENV["MONGOHQ_URL"] is set' do
      ENV['MONGOHQ_URL'] = 'mongodb://foo.com/bar'
      Tronprint.default_config[:aggregator_options][:adapter].should == :mongodb
      Tronprint.default_config[:aggregator_options][:uri].should == 'mongodb://foo.com/bar'
    end
  end

  describe '.aggregator_options' do
    before :each do
      ENV['MONGOHQ_URL'] = nil
      Tronprint.config = nil
      Tronprint.instance_variable_set :@aggregator_options, nil
    end
    it 'loads default aggregator options' do
      Tronprint.aggregator_options.should == Tronprint.default_config[:aggregator_options]
    end
    it 'loads custom aggregator options' do
      Tronprint.config = {
        :aggregator_options => { :uri => 'foo' }
      }
      Tronprint.aggregator_options[:uri].should == 'foo'
    end
    it 'loads options for the current Rails environment' do
      Tronprint.config = {
        :aggregator_options => { 
          :production => {
            :uri => 'production_uri'
          },
          :development => {
            :uri => 'development_uri'
          }
        }
      }
      Tronprint.aggregator_options[:uri].should == 'development_uri'
    end
    it 'loads default configs if one environment is configured, but current is not' do
      Tronprint.config = {
        :aggregator_options => { 
          :production => {
            :uri => 'production_uri'
          }
        }
      }
      Tronprint.aggregator_options.should == Tronprint.default_config[:aggregator_options]
    end
  end
end
