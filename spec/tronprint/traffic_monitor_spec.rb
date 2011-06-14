require 'spec_helper'
require 'timecop'

describe Tronprint::TrafficMonitor do
  let(:aggregator) { Tronprint::Aggregator.new :adapter => :memory }
  let(:traffic_monitor) { Tronprint::TrafficMonitor.new aggregator, 'my_app' }

  describe '#increment' do
    it 'increments the user count for each time slice' do
      Timecop.freeze Time.parse('2011-06-02 13:23:01')
      2.times { traffic_monitor.increment }
      aggregator['my_app/requests'].should == 2
      aggregator['my_app/requests/by_date/2011'].should == 2
      aggregator['my_app/requests/by_date/2011/06'].should == 2
      aggregator['my_app/requests/by_date/2011/06/02'].should == 2
      aggregator['my_app/requests/by_date/2011/06/02/13'].should == 2
      aggregator['my_app/requests/hourly/13'].should == 2
    end
    it 'increments the toal recorded requests' do
      traffic_monitor.increment
      traffic_monitor.requests.should == 1
      traffic_monitor.increment
      traffic_monitor.requests.should == 2
    end
  end

  describe '#requests' do
    it 'returns 0 on the first run' do
      traffic_monitor.requests.should == 0
    end
    it 'returns the total number of requests' do
      aggregator['my_app/requests'] = 13
      traffic_monitor.requests.should == 13
    end
  end
end

