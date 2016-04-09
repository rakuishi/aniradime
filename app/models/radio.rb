class Radio < ActiveRecord::Base
  belongs_to :radio_station

  # TODO: 画像はサーバーに保存して使用する
  def self.create_or_update_with(name, description, url, image_url, published_at, radio_station)
    radio = Radio.find_or_initialize_by(name: name, published_at: published_at.to_datetime)
    radio.name = name
    radio.description = description
    radio.url = url
    radio.image_url = image_url
    radio.published_at = published_at
    radio.radio_station = radio_station
    radio.save
  end
end
