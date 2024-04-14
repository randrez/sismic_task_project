
require 'concurrent'
require 'rufus-scheduler'
require 'httparty'
require_relative '../tools/constants'
require_relative '../tools/utils'

class GetFeatureTask
  include Concurrent::Async

  def initialize
    @url = Constants::URL
    @options = {headers: {"Accept" => "application/json"},query: {format: 'json'}}
  end

  def start
      fetch_features_data_from_usgs
      scheduler = Rufus::Scheduler.new
      scheduler.every '1m' do
        fetch_features_data_from_usgs
      end
      scheduler.join
  rescue Exception => e
      puts e.message
  end

  def fetch_features_data_from_usgs
    response = HTTParty.get(@url, @options)
    if response.success?
      json = JSON.parse(response.body)
      features  = json['features']
      features_result = validate_features_exists(features)
      if features_result.size > 0
        save_all_features(features_result)
      end
    else
      puts "Error fetching seismic data: #{response.code}"
    end
  rescue Exception => e
    puts e.message
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

    Feature.insert_all(features_data)
  rescue Exception => e
    puts e.message
  end

  def validate_features_exists(feature_response)
    existing_external_ids = Feature.pluck(:external_id)
    features_to_insert = feature_response.reject { |feature| existing_external_ids.include?(feature['id']) }
    features_to_insert
  end

end
