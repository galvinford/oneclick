class Place < ActiveRecord::Base

  # associations
  belongs_to  :user
  belongs_to  :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to  :poi       # optional
  has_many    :trip_places # optional
  
  attr_accessible :name, :address1, :address2, :city, :state, :zip, :lat, :lon, :raw_address
  
  scope :active, where("places.active = true")
  default_scope order("name")
  
  # Returns true if the user can delete this place from their My Places
  # false otherwise
  def can_delete
    # check all the trip plces associated with this place
    trip_places.each do |tp|
      # check all the planned trips associated with each trip_place trip
      tp.trip.planned_trips.each do |pt|
        # if a planned trip is in the future we can't delete it
        if pt.in_the_future
          return false
        end
      end
    end
    # looks like they are all in the past
    return true
  end
  
  # Use this as the main method for getting a place's location
  def location
    return poi.location unless poi.nil?
    return [lat, lon]
  end
   
  def to_s
    return name
  end
  
  # convienience method for geocoding places
  def geocode
    geocoder = OneclickGeocoder.new
    geocoder.geocode(raw_address)
    res = geocoder.results
    if address = res.first
      self.name = address[:name]
      self.address1 = address[:name]
      self.city = address[:city]
      self.state = address[:state]
      self.zip = address[:zip]
      self.lat = address[:lat]
      self.lon = address[:lon]
      self.active = true      
    end  
  end
  
  def address
    if poi
      addr = poi.address
    else
      elems = []
      elems << address1 unless address1.blank?
      elems << address2 unless address2.blank?
      elems << city unless city.blank?
      elems << state unless state.blank?
      elems << zip unless zip.blank?
      addr = elems.compact.join(' ') 
      if addr.blank?
        addr = raw_address   
      end
    end
    return addr
  end
 
end
