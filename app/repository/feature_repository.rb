class FeatureRepository
  def initialize
    @model = Feature
  end

  def save_all_features(features)
    features_data = features.map do |data|
      external_id = data['id']
      properties = data['properties']
      coordinates = data['geometry']['coordinates']
      {
        external_id: external_id,
        magnitude: properties['mag'],
        place: properties['place'],
        time: Time.at(properties['time'] / 1000),
        tsunami: properties['tsunami'] > 0,
        mag_type: properties['magType'],
        title: properties['title'],
        type: properties['type'],
        url: properties['url'],
        latitude: coordinates[1],
        longitude: coordinates[0]
      }
    end

    @model.upsert_all(features_data, unique_by: :external_id)
  end

  def validate_features_exists(feature_response)
    existing_external_ids = @model.pluck(:external_id)
    features_to_insert = feature_response.reject { |feature| existing_external_ids.include?(feature['id']) }
    features_to_insert
  end
end
