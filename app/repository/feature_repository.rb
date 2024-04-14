class FeatureRepository
  def initialize
    @feature = Feature
    @log = Log
  end

  def filter(params)
    features = Set.new
    total = features.count
    current_page = 1
    per_page = 100
    mag_types = ""

    if params.present?
      if params[:per_page].present? && params[:page].present?
        per_page = params[:per_page].to_i.clamp(1, 1000)
        current_page = params[:page].to_i.clamp(1, Float::INFINITY)
      end

      if params[:mag_types].present?
        mag_types = params[:mag_types].split(',')
      end

      if mag_types.size > 0
        features = @feature.where("mag_type IN (?)", mag_types).limit(per_page).offset((current_page - 1) * per_page)
      else
        features = @feature.limit(per_page).offset((current_page - 1) * per_page)
      end
      total = features.count
    else
      features = @feature.limit(per_page).offset((current_page - 1) * per_page)
      total = features.count
    end

    return {
      list: features,
      current_page: current_page,
      total: total,
      per_page: per_page
    }
  rescue Exception => e
    save_log(e.backtrace, e.message)
  end

  private

  def save_log(trace, message)
    Log.create(trace:trace, message:message)
  end

end
