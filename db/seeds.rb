# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def setupRadioStations
  stations = [
    {
      id: 1,
      name: 'シーサイド',
      url: 'http://ch.nicovideo.jp/seaside-channel',
      parse_url: 'http://ch.nicovideo.jp/seaside-channel/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
    {
      id: 2,
      name: 'セカンドショット',
      url: 'http://ch.nicovideo.jp/secondshot',
      parse_url: 'http://ch.nicovideo.jp/secondshot/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
    {
      id: 3,
      name: '音泉',
      url: 'http://www.onsen.ag/',
      parse_url: 'http://www.onsen.ag/',
      parse_url_type: 'onsen',
    },
    {
      id: 4,
      name: 'アニメイトTV',
      url: 'http://www.animate.tv/radio/',
      parse_url: 'http://www.animate.tv/radio/',
      parse_url_type: 'animate'
    },
    {
      id: 5,
      name: '超！アニメディア',
      url: 'http://ch.nicovideo.jp/animedia',
      parse_url: 'http://ch.nicovideo.jp/animedia/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    }
  ]

  stations.each do |station|
    RadioStation.find_or_initialize_by(id: station[:id]).update_attributes(
      name: station[:name],
      url: station[:url],
      parse_url: station[:parse_url],
      parse_url_type: station[:parse_url_type],
    )
  end
end

setupRadioStations()
