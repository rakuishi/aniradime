require 'rexml/document'
require 'action_view'

class Lantis
  def self.load
    radios = []
    radio_station = RadioStation.find_parse_url_type('lantis').first()
    return radios unless radio_station.present?

    xml = get_response_body(radio_station.parse_url)
    return radios unless xml.present?

    document = REXML::Document.new(xml)
    document.elements.each('/rss/channel/item') do |item|
      radio = parse(item, radio_station)
      radios.push(radio) if radio.present?
    end

    radios
  end

  def self.parse(item, radio_station)
    content = item.elements['content:encoded'].text
    match = content.match(/<img src="(.+?)" alt=".+?" \/>/)

    {
      name: item.elements['title'].text,
      description: ActionView::Base.full_sanitizer.sanitize(content).gsub(/(\s)/, '').slice(0, 255),
      url: item.elements['link'].text,
      image_url: match.present? && match.size == 2 ? match[1] : nil,
      published_at: Time.parse(item.elements['pubDate'].text).to_datetime,
      radio_station: radio_station
    }
  end

  def self.get_response_body(uri_string)
    uri = URI.parse uri_string
    response = Net::HTTP.get_response uri
    case response
    when Net::HTTPSuccess then
      response.body
    else
      nil
    end
  end
end
