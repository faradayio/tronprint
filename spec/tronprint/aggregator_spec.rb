require 'spec_helper'
require 'sandbox'

describe Tronprint::Aggregator do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }

  describe '#update' do
    it 'should write statistics to an uninitailzed key' do
      aggregator.update('foo/bar', 22.1)
      aggregator['foo/bar'].should == 22.1
    end
    it 'should cumulatively update statistics' do
      aggregator.update('foo/bar', 22.1)
      aggregator.update('foo/bar', 44.2)
      aggregator['foo/bar'].should be_within(0.01).of(66.3)
    end
  end
end
