require 'nokogiri'
require 'open-uri'
require 'action_view'

class AnimateWorker
  def self.task
    radio_station = RadioStation.find_parse_url_type('animate').first()
    return unless radio_station.present?

    doc = Nokogiri::HTML(open(radio_station.parse_url))
    doc.xpath('//div[@class="radioList"]//div[@id="irr"]//div[@class="box"]').each do |node|
      url = URI.parse(radio_station.parse_url)
      base_url = url.scheme + '://' + url.host
      text_node = node.xpath('div[@class="textBox"]')
      published_at = text_node.xpath('span[@class="date"]').inner_text

      Radio.create_or_update_with(
        text_node.xpath('span[@class="title"]').inner_text,
        ActionView::Base.full_sanitizer.sanitize(text_node.xpath('span[@class="main"]').inner_text).gsub(/(\s)/, ''),
        base_url + node.xpath('a').attribute('href').text,
        base_url + node.xpath('span[@class="img"]//img').attribute('src').text,
        published_at,
        radio_station
      )
    end
  end  
end
