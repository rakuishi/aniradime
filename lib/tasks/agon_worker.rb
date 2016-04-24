require 'nokogiri'
require 'open-uri'
require 'action_view'

class AgonWorker
  def self.task
    radio_station = RadioStation.find_parse_url_type('agon').first()
    return unless radio_station.present?

    doc = Nokogiri::HTML(open(radio_station.parse_url))
    doc.xpath('//a[@class="cb_link"]').each do |node|
      save_contents(node.attribute('href').text, radio_station)
    end
  end

  def self.save_contents(url, radio_station)
    # ラジオ詳細ページの URL をチェックする
    return unless url.start_with?('http://ondemand.joqr.co.jp/AG-ON/contents/')

    doc = Nokogiri::HTML(open(url))
    node = doc.xpath('//div[@id="secinfo"]')
    return if node.blank?

    name = sanitize(node.xpath('div[@id="right"]/div[@id="Nleft"]//h3[@class="sinf_title"]').inner_text)
    description = sanitize(node.xpath('div[@id="left"]/p[@class="sinf_txt"]').inner_text)
    thumbnail = get_thumbnail(node.xpath('div[@id="left"]//img'))
    published_at = get_published_at(node.xpath('div[@id="right"]/div[@id="Nleft"]//ul[@class="sinf_det"]/li'))

    Radio.create_or_update_with(
      name,
      description,
      url,
      thumbnail,
      published_at,
      radio_station
    )
  end

  def self.get_published_at(nodes)
    nodes.each do |node|
      label = sanitize(node.xpath('span[@class="detli"]').inner_text)
      if label.start_with?('公開日')
        text = sanitize(node.xpath('span[@class="detlitxt"]').inner_text)
        begin
          return Time.strptime(text, '%Y年%m月%d日').to_datetime
        rescue Exception => e
          return nil
        end
      end
    end

    nil
  end

  def self.get_thumbnail(imgs)
    imgs.each do |img|
      src = img.attribute('src').text
      return src if src.start_with?('http://ondemand.joqr.co.jp/AG-ON/bangumi/assets_c/')
    end

    nil
  end

  def self.sanitize(text)
    ActionView::Base.full_sanitizer.sanitize(text)
  end
end
