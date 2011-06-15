require 'spec_helper'
require 'tronprint/statistics_formatter'
require 'action_view'

class StatisticsFormatterHarness
  include ActionView::Helpers
  include Tronprint::StatisticsFormatter
end

describe Tronprint::StatisticsFormatter do
  let(:formatter) { StatisticsFormatterHarness.new }

  describe '#pounds_with_precision' do
    it 'converts kilograms to pounds' do
      formatter.pounds_with_precision(1).should == '2.2046'
    end
    it 'uses a precision of 4 if the number is less than 100' do
      formatter.pounds_with_precision(8).should == '17.6368'
    end
    it 'uses a precision of 4 if the number is 0' do
      formatter.pounds_with_precision(0).should == '0.0000'
    end
    it 'uses a precision of 0 if the number is at least 100' do
      formatter.pounds_with_precision(60).should == '132.2760'
    end
  end
end

