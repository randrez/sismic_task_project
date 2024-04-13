require 'pry'
require 'concurrent'
require 'rufus-scheduler'
require 'httparty'
require 'json'
require_relative '../tools/constants'

class GetEarthquakeTask
  include HTTParty
  include Concurrent::Async

  def initialize
    @url = Constants::URL
    @options = { query: { format: 'geojson' } }
  end

  def init
      scheduler = Rufus::Scheduler.new
      scheduler.every '1m' do
        execute_fetch_save
      end
      scheduler.join
  end

  def execute_fetch_save
    data = fetch_earthquake_data_from_usgs
    save_earthquake_data(data) if data.present?
  rescue StandardError => e
    if e.nil?
      puts e.inspect
      puts.e.message
    end
  end

  def fetch_earthquake_data_from_usgs
    puts @url
    response = HTTParty.get(@url, @options)
    puts response.body
    if response.nil?
      puts response
      puts "La respuesta no es nula"
      handle_response(response)
    else
      puts "La respuesta es nula"
    end
  end

  def save_earthquake_data(data)
    puts data
  end

  def handle_response(response)
    if response.success?
      parsed_response = JSON.parse(response.body)
      parsed_response['features']
    else
      puts "Error fetching seismic data: #{response.code}"
    end
  end

  def handle_error(error)
    raise StandardError, "Error fetching seismic data: #{error.message}"
  end
end
