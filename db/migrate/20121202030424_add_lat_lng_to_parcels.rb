class AddLatLngToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :lat, :float
    add_column :parcels, :lng, :float
  end
end
