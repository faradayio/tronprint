require 'spec_helper'
require 'tronprint/rails/tronprint_helper'

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
end

