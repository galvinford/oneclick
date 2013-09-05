require 'spec_helper'
require 'time'

describe TripsController do
  describe "POST #create" do
    it "creates a trip, given correct parameters" do
      FactoryGirl.create(:trip_status)
      geocoder = double()
      geocoder.should_receive(:geocode).with('bar')
      geocoder.should_receive(:results).and_return [{street_address: '1 bar st', lat: 1.0, lon: 2.0}]
      geocoder.should_receive(:geocode).with('boot')
      geocoder.should_receive(:results).and_return [{street_address: '1 boot st', lat: 1.0, lon: 2.0}]
      OneclickGeocoder.stub(:new).and_return(geocoder)
      post :create, user_id: FactoryGirl.create(:user).id, trip_proxy:
        {
          from_place: 'bar',
          to_place: 'boot',
          trip_date: Date.today.strftime("%m/%d/%Y"),
          trip_time: (Time.now + 1.hour).strftime("%I:%M %p"),
          trip_purpose_id: FactoryGirl.create(:trip_purpose).id
        }
      puts "response.body:"
      puts response.body
      puts response.headers
      assigns(:trip_proxy).should eq('blar')
      assigns(:planned_trip).should eq('blat')
    end    
  end
end
