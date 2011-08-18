require 'spec_helper'
require 'tronprint/rails/tronprint_helper'
require 'timeout'

describe TronprintHelper do
  let :helper do
    c = Class.new
    c.send :include, TronprintHelper
    c.new
  end

  describe '#total_footprint' do
    it 'returns the total footprint' do
      Tronprint.statistics.stub!(:emission_estimate).and_return mock(Object, :to_f => 89.4)
      helper.total_footprint.should == 89.4
    end
  end

  describe '#footprint_badge' do
    it 'outputs a badge' do
      helper.stub!(:pounds_with_precision).and_return "100.0"
      helper.stub!(:total_estimate).and_return 100.0
      Tronprint.statistics.stub!(:emission_estimate).and_return 100.0
      helper.stub!(:total_electricity).and_return 20
      helper.footprint_badge.should =~ /Total app footprint/
    end
    it 'gracefully handles lost aggregator connections' do
      module Mongo; class OperationTimeout < Timeout::Error; end; end
      helper.stub!(:total_estimate).and_raise Mongo::OperationTimeout
      helper.footprint_badge.should =~ /App footprint unavailable/
    end
  end
end

