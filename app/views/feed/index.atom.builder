atom_feed do |feed|
  # TODO: 定数ファイルを用意する
  feed.title('aniradime - アニラジ更新情報')
  feed.updated((@radios.first.created_at))
  feed.author do |author|
    feed.name('rakuishi')
    feed.email('rakuishi@gmail.com')
    feed.uri('http://radio.rakuishi.com/')
  end

  @radios.each do |radio|
    feed.entry(radio, url: radio.url) do |entry|
      entry.title(radio.name)
      entry.summary(radio.description.gsub(/(\s)/, ''))
      entry.author do |author|
        author.name(radio.radio_station.name)
        author.uri(radio.radio_station.url)
      end
    end
  end
end
