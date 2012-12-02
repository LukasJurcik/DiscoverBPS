class Parcel < ActiveRecord::Base
  has_many :schools
  before_save :geocode_address
  
  private 
  
  def geocode_address
    # boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
    geo = Geokit::Geocoders::MultiGeocoder.geocode("#{address}, Boston, MA, #{zipcode}")
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end
end
