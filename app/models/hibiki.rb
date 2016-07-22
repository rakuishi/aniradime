require 'net/http'
require 'uri'
require 'json'

class Hibiki
  def self.load
    radios = []
    radio_station = RadioStation.find_parse_url_type('hibiki').first()
    return radios unless radio_station.present?

    base_url = 'https://vcms-api.hibiki-radio.jp/api/v1//programs?day_of_week=%s&limit=8&page=1'
    weeks = ['mon', 'tue', 'wed', 'thu', 'fri', 'satsun']

    weeks.each do |week|
      url = sprintf(base_url, week)
      response = get_response_body(url)
      return radios unless response.present?

      json = JSON.parse(response)
      return radios unless json.present?
      
      json.each do |item|
        radio = parse(item, radio_station)
        radios.push(radio) if radio.present?
      end
    end

    radios
  end

  def self.parse(item, radio_station)
    {
      name: item['name'],
      description: item['description'].slice(0, 255),
      url: sprintf('http://hibiki-radio.jp/description/%s/detail', item['access_id']),
      image_url: item['sp_image_url'],
      published_at: Time.parse(item['episode_updated_at']).to_datetime,
      radio_station: radio_station
    }
  end

  def self.get_response_body(uri_string)
    uri = URI.parse(uri_string)
    https = Net::HTTP.new(uri.host, uri.port)
 
    https.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)

    request.add_field('X-Requested-With', 'XMLHttpRequest')
    response = https.request(request)

    case response
    when Net::HTTPSuccess then
      response.body
    else
      nil
    end
  end
end
