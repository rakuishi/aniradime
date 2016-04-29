require 'nokogiri'
require 'open-uri'
require 'action_view'

class Animate
  def self.load
    radios = []
    radio_station = RadioStation.find_parse_url_type('animate').first()
    return radios unless radio_station.present?

    url = URI.parse(radio_station.parse_url)
    base_url = url.scheme + '://' + url.host

    doc = Nokogiri::HTML(open(radio_station.parse_url))
    doc.xpath('//div[@class="radioList"]//div[@id="irr"]//div[@class="box"]').each do |node|
      radio = parse(base_url, node, radio_station)
      radios.push(radio) if radio.present?
    end

    radios
  end

  def self.parse(base_url, node, radio_station)
    text_node = node.xpath('div[@class="textBox"]')
    published_at = text_node.xpath('span[@class="date"]').inner_text

    {
      name: text_node.xpath('span[@class="title"]').inner_text,
      description: ActionView::Base.full_sanitizer.sanitize(text_node.xpath('span[@class="main"]').inner_text).gsub(/(\s)/, ''),
      url: base_url + node.xpath('a').attribute('href').text,
      image_url: base_url + node.xpath('span[@class="img"]//img').attribute('src').text,
      published_at: Time.parse(published_at).to_datetime,
      radio_station: radio_station
    }
  end
end
