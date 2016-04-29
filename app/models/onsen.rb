require 'nokogiri'
require 'open-uri'
require 'action_view'

class Onsen
  def self.load
    radio_station = RadioStation.find_parse_url_type('onsen').first()
    return unless radio_station.present?

    radios = []
    url = URI.parse(radio_station.parse_url)
    base_url = url.scheme + '://' + url.host

    doc = Nokogiri::HTML(open(radio_station.parse_url))
    doc.xpath('//section[@id="movieList"]//div[@class="listWrap"]//ul[@class="clr"]//li').each do |node|
      radio = parse(base_url, node, radio_station)
      radios.push(radio) if radio.present?
    end

    radios
  end

  def self.parse(base_url, node, radio_station)
    name = node.xpath('h4[@class="listItem"]').inner_text
    image_url = base_url + node.xpath('p[@class="thumbnail listItem"]//img').attribute('src').text
    description = ActionView::Base.full_sanitizer.sanitize(node.xpath('p[@class="navigator listItem"]').inner_text)

    # `data-update` が空白、noMovie を含む番組は排除する
    published_at = node.attribute('data-update').text
    return nil if published_at.blank?
    return nil if node.attribute('class').text.include?('noMovie')

    {
      name: name,
      description: description,
      url: base_url + '/?pid=' + node.attribute('id').text,
      image_url: image_url,
      published_at: Time.parse(published_at).to_datetime,
      radio_station: radio_station
    }
  end
end
