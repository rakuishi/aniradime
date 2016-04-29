require 'rexml/document'
require 'action_view'

class Chnicovideo
  def self.load
    radios = []

    RadioStation.find_parse_url_type('chnicovideo').each do |radio_station|
      xml = get_response_body(radio_station.parse_url)
      next unless xml.present?

      document = REXML::Document.new(xml)
      document.elements.each('/rss/channel/item') do |item|
        radio = parse(item, radio_station)
        radios.push(radio) if radio.present?
      end
    end

    radios
  end

  def self.parse(item, radio_station)
    match = item.elements['description'].text.match(/<img alt=".+?" src="(.+?)" width="\d+" height="\d+" border="0"\/>/)

    {
      name: item.elements['title'].text,
      description: ActionView::Base.full_sanitizer.sanitize(item.elements['description'].text).gsub(/(\s)/, '').slice(0, 255),
      url: item.elements['link'].text,
      image_url: match.size == 2 ? match[1] : nil,
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
