class RadioStation < ActiveRecord::Base
  enum parse_url_type: {
    chnicovideo: 0,
  }

  scope :find_parse_url_type, -> (type) { where(parse_url_type: RadioStation.parse_url_types[type]) }

end
