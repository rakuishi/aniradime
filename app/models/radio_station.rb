class RadioStation < ActiveRecord::Base
  enum parse_url_type: {
    chnicovideo: 0,
  }

end
