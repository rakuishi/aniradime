require 'nokogiri'
require 'open-uri'
require 'action_view'

class OnsenWorker
  def self.task
    radio_station = RadioStation.find_parse_url_type('onsen').first()
    return unless radio_station.present?

    doc = Nokogiri::HTML(open(radio_station.parse_url))
    doc.xpath('//section[@id="movieList"]//div[@class="listWrap"]//ul[@class="clr"]//li').each do |node|
      url = URI.parse(radio_station.parse_url)
      base_url = url.scheme + '://' + url.host
      name = node.xpath('h4[@class="listItem"]').inner_text
      image_url = base_url + node.xpath('p[@class="thumbnail listItem"]//img').attribute('src').text
      description = ActionView::Base.full_sanitizer.sanitize(node.xpath('p[@class="navigator listItem"]').inner_text)

      # TODO: TimeZone +09:00 を考慮する
      published_at = node.attribute('data-update').text
      # 新番組は、`data-update` に値が存在しない
      next unless published_at.present?

      Radio.create_or_update_with(
        name,
        description,
        base_url + '/?pid=' + node.attribute('id').text,
        image_url,
        published_at,
        radio_station
      )
    end
  end
end
