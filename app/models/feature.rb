class Feature < ApplicationRecord
  validates_presence_of :external_id, :title, :url, :place, :mag_type
  validates_inclusion_of :magnitude, in: -1.0..10.0
  validates_inclusion_of :latitude, in: -90.0..90.0
  validates_inclusion_of :longitude, in: -180.0..180.0
  has_many :comments
end
