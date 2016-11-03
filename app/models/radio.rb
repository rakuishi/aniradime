require 'digest/md5'
require 'open-uri'
require 'fileutils'

class Radio < ActiveRecord::Base
  belongs_to :radio_station

  def self.create_or_update_with_radios(radios)
    radios.each do |radio|
      create_or_update_with_radio(radio)
    end
  end

  def self.create_or_update_with_radio(radio)
    if radio.blank? or radio[:name].blank? or radio[:description].blank? or radio[:url].blank? or radio[:image_url].blank? or radio[:published_at].blank? or radio[:radio_station].blank?
      return
    end

    Radio.find_or_initialize_by(name: radio[:name], published_at: radio[:published_at]).update_attributes(
      name: radio[:name],
      description: radio[:description],
      url: radio[:url],
      image_url: download_image_if_needed(radio[:image_url]),
      published_at: radio[:published_at],
      radio_station: radio[:radio_station],
    )
  end

  def self.download_image_if_needed(image_url)
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

  def self.all_to_json(offset, limit)
    Radio.includes(:radio_station).references(:radio_stations).order(published_at: :desc).offset(offset).limit(limit).map(&:to_json)
  end

  def to_json
    {
      id: self.id,
      name: self.name,
      url: self.url,
      image_url: "#{Rails.application.config.base_uri}#{self.image_url}",
      description: self.description,
      published_at: self.published_at.iso8601,
      radio_station_id: self.radio_station_id,
      station: {
        id: self.radio_station.id,
        name: self.radio_station.name,
        url: self.radio_station.url,
      }
    }
  end
end
