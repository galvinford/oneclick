class PlannedTrip < ActiveRecord::Base
  
  #associations
  belongs_to :trip
  belongs_to :trip_status
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many :itineraries
  has_many :valid_itineraries, :conditions => 'server_status=200 AND hidden=false', :class_name => 'Itinerary' 
  has_many :hidden_itineraries, :conditions => 'server_status=200 AND hidden=true', :class_name => 'Itinerary'

  validate :trip_status, presence: true

  attr_accessible :trip_datetime, :is_depart
 
  # Scopes
  scope :created_between, lambda {|from_day, to_day| where("planned_trips.created_at > ? AND planned_trips.created_at < ?", from_day.at_beginning_of_day, to_day.tomorrow.at_beginning_of_day) }
 
  # Returns an array of PlannedTrip that have at least one valid itinerary but all
  # of them have been hidden by the user
  def self.rejected
    joins(:itineraries).where('server_status=200 AND hidden=true')
  end
  # Returns an array of PlannedTrip where no valid options were generated
  def self.failed
    joins(:itineraries).where('server_status <> 200')
  end
  
  # returns true if the planned trip is scheduled in advance of
  # the current or passed in date
  def in_the_future(now=Time.now)
    trip_datetime > now
  end
  
  def create_itineraries
    create_fixed_route_itineraries
    create_paratransit_itineraries
    create_rideshare_itineraries
    create_taxi_itineraries
  end

  # TODO refactor following 3 methods
  def create_fixed_route_itineraries
    tp = TripPlanner.new
    arrive_by = !is_depart
    from_place = trip.trip_places.first
    to_place = trip.trip_places.last
    result, response = tp.get_fixed_itineraries([from_place.location.first, from_place.location.last],[to_place.location.first, to_place.location.last], trip_datetime.in_time_zone, arrive_by.to_s)
    if result
      tp.convert_itineraries(response).each do |itinerary|
        itineraries << Itinerary.new(itinerary)
      end
    else
      itineraries << Itinerary.new('server_status'=>response['id'], 'server_status'=>response['msg'])
    end
  end

  def create_taxi_itineraries
    tp = TripPlanner.new
    from_place = trip.trip_places.last
    to_place = trip.trip_places.last
    result, response = tp.get_taxi_itineraries([from_place.location.first, from_place.location.last],[to_place.location.first, to_place.location.last], trip_datetime.in_time_zone)
    if result
      itinerary = tp.convert_taxi_itineraries(response)
      self.itineraries << Itinerary.new(itinerary)
    else
      self.itineraries << Itinerary.new('server_status'=>500, 'server_message'=>response)
    end
  end

  def create_paratransit_itineraries
    #TODO: This is just a place holder that currently returns demo data only.
    tp = TripPlanner.new
    eh = EligibilityHelpers.new
    passenger_eligible_services = eh.get_accommodating_and_eligible_services_for_traveler(creator.user_profile)
    passenger_and_trip_eligible_services = eh.get_eligible_services_for_trip(self, passenger_eligible_services)
    passenger_and_trip_eligible_services.each do |service|

      itinerary = tp.convert_paratransit_itineraries(service)
      self.itineraries << Itinerary.new(itinerary)
    end
  end

  def create_rideshare_itineraries
    tp = TripPlanner.new
    from_place = trip.trip_places.first
    to_place = trip.trip_places.last
    result, response = tp.get_rideshare_itineraries(from_place, to_place, trip_datetime.in_time_zone)
    if result
      itinerary = tp.convert_rideshare_itineraries(response)
      itineraries << Itinerary.new(itinerary)
    else
      itineraries << Itinerary.new('server_status'=>500, 'server_message'=>response)
    end
  end
 
end
