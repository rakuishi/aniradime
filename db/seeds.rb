# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def setupRadioStations
  RadioStation.first_or_create([
    {
      id: 1,
      name: 'シーサイドチャンネル',
      url: 'http://ch.nicovideo.jp/seaside-channel',
      parse_url: 'http://ch.nicovideo.jp/seaside-channel/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
    {
      id: 2,
      name: 'セカンドショットちゃんねる',
      url: 'http://ch.nicovideo.jp/secondshot',
      parse_url: 'http://ch.nicovideo.jp/secondshot/video?rss=2.0',
      parse_url_type: 'chnicovideo',
    },
    {
      id: 3,
      name: 'インターネットラジオステーション＜音泉＞',
      url: 'http://www.onsen.ag/',
      parse_url: 'http://www.onsen.ag/',
      parse_url_type: 'onsen',
    },
    {
      id: 4,
      name: 'アニメイトTV ウェブラジオ',
      url: 'http://www.animate.tv/radio/',
      parse_url: 'http://www.animate.tv/radio/',
      parse_url_type: 'animate'
    }
  ])
end

setupRadioStations()
