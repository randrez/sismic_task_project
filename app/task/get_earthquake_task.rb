
require 'concurrent'
require 'rufus-scheduler'
require 'httparty'
require_relative '../tools/constants'
require_relative  '../tools/utils'

class GetEarthquakeTask
  include Concurrent::Async

  def initialize
    @url = Constants::URL
    @options = {headers: {"Accept" => "application/json"},query: {format: 'json'}}
  end

  def start
      repository = FeatureRepository.new
      scheduler = Rufus::Scheduler.new
      scheduler.every '1m' do
        fetch_features_data_from_usgs(repository)
      end
      scheduler.join
      fetch_features_data_from_usgs(repository)
  end

  def fetch_features_data_from_usgs(repository)
    response = HTTParty.get(@url, @options)
    if response.success?
      json = JSON.parse(response.body)
      features  = json['features']
      features_result = repository.validate_features_exists(features)
      if features_result.size > 0
        repository.save_all(features_result)
      end
    else
      puts "Error fetching seismic data: #{response.code}"
    end
  end

end
