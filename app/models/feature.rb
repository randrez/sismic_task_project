class Feature < ApplicationRecord
  has_many :comments
  has_one :coordinate
end
