require 'rexml/document'
require 'action_view'

class ChnicovideoWorker
  include ActionView::Helpers::SanitizeHelper

  def self.task
    RadioStation.where(parse_url_type: 'chnicovideo').each do |radio_station|
      xml = get_response_body(radio_station.parse_url)
      return unless xml.present?

      document = REXML::Document.new(xml)
      document.elements.each('/rss/channel/item') do |item|
        match = item.elements['description'].text.match(/<img alt=".+?" src="(.+?)" width="\d+" height="\d+" border="0"\/>/)

        Radio.create_or_update_with(
          item.elements['title'].text,
          ActionView::Base.full_sanitizer.sanitize(item.elements['description'].text).gsub(/(\s)/, '').slice(0, 255),
          item.elements['link'].text,
          match.size == 2 ? match[1] : nil,
          item.elements['pubDate'].text,
          radio_station
        )
      end
    end
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
