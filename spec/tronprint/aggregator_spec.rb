require 'spec_helper'
require 'sandbox'

describe Tronprint::Aggregator do
  let(:sandbox) { Sandbox.new }
  before :each do
    Tronprint::Aggregator.file_path = File.join(sandbox.path, 'agg.yml')
  end
  after :each do
    sandbox.close
    Tronprint::Aggregator.clear_cache!
  end

  describe '.write' do
    it 'should write statistics to an uninitailzed key' do
      Tronprint::Aggregator.write('foo/bar', 22.1)
      Tronprint::Aggregator.read('foo/bar').should == 22.1
    end
    it 'should overwrite an existing key' do
      Tronprint::Aggregator.write('foo/bar', 22.1)
      Tronprint::Aggregator.write('foo/bar', 33.2)
      Tronprint::Aggregator.read('foo/bar').should == 33.2
    end
    it 'should unlock the file if something goes wrong' do
      mock_file = mock File, :flock => nil, :close => nil
      File.stub!(:open).and_return mock_file
      mock_file.should_receive(:flock).with(File::LOCK_UN)
      YAML.stub!(:dump).and_raise StandardError
      begin
        Tronprint::Aggregator.write('foo/bar', 22.1)
      rescue
      end
    end
  end

  describe '.update' do
    it 'should write statistics to an uninitailzed key' do
      Tronprint::Aggregator.update('foo/bar', 22.1)
      Tronprint::Aggregator.read('foo/bar').should == 22.1
    end
    it 'should cumulatively update statistics' do
      Tronprint::Aggregator.update('foo/bar', 22.1)
      Tronprint::Aggregator.update('foo/bar', 44.2)
      Tronprint::Aggregator.read('foo/bar').should be_within(0.01).of(66.3)
    end
  end

  describe '.read' do
    it 'should return nil if a key is nonexistent' do
      Tronprint::Aggregator.read('foos/bar').should be_nil
    end
    it 'should return the value stored for the key' do
      Tronprint::Aggregator.write('foo/bar', 22.1)
      Tronprint::Aggregator.read('foo/bar').should == 22.1
    end
  end

  describe '.clear_cache!' do
    it 'should clear the cache' do
      Tronprint::Aggregator.cached_data['foo'] = 'bar'
      Tronprint::Aggregator.clear_cache!
      Tronprint::Aggregator.cached_data['foo'].should be_nil
    end
  end

  describe '.data' do
    before :each do
      File.stub!(:exist?).and_return true
    end
    it 'should return an empty hash if there is no saved data' do
      File.stub!(:exist?).and_return false
      Tronprint::Aggregator.data.should == {}
    end
    it 'should return an empty hash if a non-hash was saved' do
      YAML.stub!(:load_file).and_return false
      Tronprint::Aggregator.data.should == {}
    end
    it 'should return the saved data' do
      YAML.stub!(:load_file).and_return({ :hi => 'there' })
      Tronprint::Aggregator.data.should == { :hi => 'there' }
    end
  end
end

