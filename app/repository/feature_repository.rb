class FeatureRepository
  def initialize
    @model = Feature
  end

  def all(params)
    features  = @model.all

    features  = features.where(mag_type: params[:mag_type].split(',')) if params[:mag_type].present?

    per_page = params[:per_page].to_i.clamp(1, 1000)
    current_page = params[:page].to_i.clamp(1, Float::INFINITY)
    total = features.count
    features = features.limit(per_page).offset((current_page - 1) * per_page)

    list_data = features.map do |feature|
      json:{
        id: feature.id,
        type: feature.type,
        attributes: {
          external_id: feature.external_id,
          magnitude: feature.magnitude,
          place: feature.place,
          time: feature.time,
          tsunami: feature.tsunami,
          mag_type: feature.mag_type,
          title: feature.title,
          coordinates: {
            longitude: feature.longitude,
            latitude: feature.latitude
          }
        },
        links: json:{
          external_url: feature.url
        }
      }
    end

    render json: {
      data: list_data,
      pagination: {
        current_page: current_page,
        total: total,
        per_page: per_page
      }
    }
  end

end
