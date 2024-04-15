class Api::FeaturesController < ApplicationController

  def initialize(feature_repository = FeatureRepository.new, comment_repository = CommentRepository.new)
    @feature_repository = feature_repository
    @comment_repository = comment_repository
  end

  def index
    filter_result = @feature_repository.filter(params)
    if filter_result.present?
      list_data = filter_result[:list].map do |feature|
        {
          id: feature.id,
          type: feature.feature_type,
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
          links: {
            external_url: feature.url
          }
        }
      end

      render json:   {
        data: list_data,
        pagination: {
          current_page: filter_result[:current_page],
          total: filter_result[:total],
          per_page: filter_result[:per_page]
        }
      }, status: :ok
    else
      render json: { error: "features not found" }, status: :bad_request
    end
  end

  def create_comment
    @comment_repository.save(comment_params, params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
