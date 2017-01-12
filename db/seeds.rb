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
    },
    {
      id: 6,
      name: 'AG-ON',
      url: 'http://ondemand.joqr.co.jp/AG-ON/',
      parse_url: 'http://ondemand.joqr.co.jp/AG-ON/',
      parse_url_type: 'agon',
    },
    {
      id: 7,
      name: 'Lantis',
      url: 'http://lantis-net.com/',
      parse_url: 'http://lantis-net.com/rss/news.xml',
      parse_url_type: 'lantis',
    },
    {
      id: 8,
      name: 'HiBiKi Radio Station',
      url: 'http://hibiki-radio.jp/',
      parse_url: 'http://hibiki-radio.jp/',
      parse_url_type: 'hibiki',
    },
    {
      id: 9,
      name: '東山奈央のドリーム＊シアター',
      url: 'http://ch.nicovideo.jp/nao-dream',
      parse_url: 'http://ch.nicovideo.jp/nao-dream/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
    {
      id: 10,
      name: '巽悠衣子チャンネル',
      url: 'http://ch.nicovideo.jp/tatsumiyuiko',
      parse_url: 'http://ch.nicovideo.jp/tatsumiyuiko/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
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
