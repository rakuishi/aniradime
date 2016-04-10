require 'digest/md5'
require 'open-uri'
require 'fileutils'

class Radio < ActiveRecord::Base
  belongs_to :radio_station

  def self.create_or_update_with(name, description, url, image_url, published_at, radio_station)
    image_url = download_image(image_url)
    published_at = Time.parse(published_at).to_datetime

    radio = Radio.find_or_initialize_by(name: name, published_at: published_at)
    radio.name = name
    radio.description = description
    radio.url = url
    radio.image_url = image_url
    radio.published_at = published_at
    radio.radio_station = radio_station
    radio.save
  end

  def self.download_image(image_url)
    return image_url unless image_url.present?

    md5 = Digest::MD5.new.update(image_url).to_s
    public_dir = "#{Rails.root}/public"
    path = "/uploads/#{md5.slice(0, 2)}/#{md5}"
    return path if File.exist?(public_dir + path)

    begin
      FileUtils.mkdir_p(File.dirname(public_dir + path))
      IO.copy_stream(open(image_url), public_dir + path)
      path
    rescue Exception => e
      image_url
    end
  end
end
