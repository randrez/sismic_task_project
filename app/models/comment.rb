class Comment < ApplicationRecord
  belongs_to :feature

  def self.by_feature_id(feature_id)
    where(feature_id: feature_id)
  end
end
