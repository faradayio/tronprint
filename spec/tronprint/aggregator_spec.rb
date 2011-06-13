require 'spec_helper'
require 'sandbox'
require 'time'
require 'timecop'

describe Tronprint::Aggregator do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }

  describe '#update' do
    let(:now) { Time.parse('2011-06-02 13:45:12') }
    before do
      Timecop.freeze now
    end
    after do
      Timecop.return
    end

    it 'writes statistics to an uninitailzed key' do
      aggregator.update('foo/bar', 22.1)
      aggregator['foo/bar'].should == 22.1
    end
    it 'cumulatively updates statistics' do
      aggregator.update('foo/bar', 22.1)
      aggregator.update('foo/bar', 44.2)
      aggregator['foo/bar'].should be_within(0.01).of(66.3)
      aggregator['foo/bar/by_date/2011'].should be_within(0.01).of(66.3)
      aggregator['foo/bar/by_date/2011/06'].should be_within(0.01).of(66.3)
      aggregator['foo/bar/by_date/2011/06/02'].should be_within(0.01).of(66.3)
      aggregator['foo/bar/by_date/2011/06/02/13'].should be_within(0.01).of(66.3)
      aggregator['foo/bar/hourly/13'].should be_within(0.01).of(66.3)
    end
    it 'stores by_date statistics in separate entries for each day, month, and year' do
      aggregator.update('foo/bar', 22.1)
      aggregator.update('foo/bar', 23.1)
      aggregator['foo/bar/by_date/2011'].should be_within(0.01).of(45.2)
      aggregator['foo/bar/by_date/2011/06'].should be_within(0.01).of(45.2)
      aggregator['foo/bar/by_date/2011/06/02'].should be_within(0.01).of(45.2)
      aggregator['foo/bar/by_date/2011/06/02/13'].should be_within(0.01).of(45.2)
      aggregator['foo/bar/hourly/13'].should be_within(0.01).of(45.2)

      Timecop.freeze Time.parse('2011-06-03 11:45:12')
      aggregator.update('foo/bar', 33.1)
      aggregator['foo/bar/by_date/2011'].should be_within(0.01).of(78.3)
      aggregator['foo/bar/by_date/2011/06'].should be_within(0.01).of(78.3)
      aggregator['foo/bar/by_date/2011/06/03'].should be_within(0.01).of(33.1)
      aggregator['foo/bar/by_date/2011/06/03/11'].should be_within(0.01).of(33.1)
      aggregator['foo/bar/hourly/11'].should be_within(0.01).of(33.1)

      Timecop.freeze Time.parse('2011-05-03 11:45:12')
      aggregator.update('foo/bar', 44.1)
      aggregator['foo/bar/by_date/2011'].should be_within(0.01).of(122.4)
      aggregator['foo/bar/by_date/2011/05'].should be_within(0.01).of(44.1)
      aggregator['foo/bar/by_date/2011/06'].should be_within(0.01).of(78.3)
      aggregator['foo/bar/by_date/2011/05/03'].should be_within(0.01).of(44.1)
      aggregator['foo/bar/by_date/2011/05/03/11'].should be_within(0.01).of(44.1)
      aggregator['foo/bar/hourly/11'].should be_within(0.01).of(77.2)

      Timecop.freeze Time.parse('2012-05-03 00:45:12')
      aggregator.update('foo/bar', 55.1)
      aggregator['foo/bar/by_date/2012'].should be_within(0.01).of(55.1)
      aggregator['foo/bar/by_date/2012/05'].should be_within(0.01).of(55.1)
      aggregator['foo/bar/by_date/2012/05/03'].should be_within(0.01).of(55.1)
      aggregator['foo/bar/by_date/2012/05/03/00'].should be_within(0.01).of(55.1)
      aggregator['foo/bar/hourly/00'].should be_within(0.01).of(55.1)

      Timecop.freeze Time.parse('2012-05-03 00:57:02')
      aggregator.update('foo/bar', 55.1)
      aggregator['foo/bar/by_date/2012'].should be_within(0.01).of(110.2)
      aggregator['foo/bar/by_date/2012/05'].should be_within(0.01).of(110.2)
      aggregator['foo/bar/by_date/2012/05/03'].should be_within(0.01).of(110.2)
      aggregator['foo/bar/by_date/2012/05/03/00'].should be_within(0.01).of(110.2)
      aggregator['foo/bar/hourly/00'].should be_within(0.01).of(110.2)
    end
  end
end
