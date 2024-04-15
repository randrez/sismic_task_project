require 'json'

class Utils

  def self.is_valid_json(json_str)
    JSON.parse(json_str)
    true
  rescue JSON::ParserError
    false
  end

end
