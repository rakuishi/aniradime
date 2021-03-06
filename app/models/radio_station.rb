class RadioStation < ActiveRecord::Base
  enum parse_url_type: {
    chnicovideo: 0,
    onsen: 1,
    animate: 2,
    agon: 3,
    lantis: 4,
    hibiki: 5,
  }

  scope :find_parse_url_type, -> (type) { where(parse_url_type: RadioStation.parse_url_types[type]) }

end
