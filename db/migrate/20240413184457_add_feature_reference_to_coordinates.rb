class AddFeatureReferenceToCoordinates < ActiveRecord::Migration[7.1]
  def change
    add_reference :coordinates, :feature, foreign_key: true
  end
end
