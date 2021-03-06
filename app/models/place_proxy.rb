class PlaceProxy < Proxy

  attr_accessor :raw_address, :name, :place_type_id, :place_id, :id
    
  validates :raw_address, :presence => true
  validates :name, :presence => true

  def initialize(attrs = {})
    super
    attrs.each do |k, v|
      self.send "#{k}=", v
    end
  end
            
end