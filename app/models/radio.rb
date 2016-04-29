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
end
