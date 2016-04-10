class MainController < ApplicationController

  # 一週間分のラジオを表示する
  def index
    @contents = {}
    for i in 0..6
      datetime = DateTime.now - i.day
      radios = Radio.includes(:radio_station).references(:radio_stations).order(published_at: :desc)
        .where('published_at BETWEEN ? AND ?', datetime.beginning_of_day, datetime.end_of_day).all
      next if radios.length == 0

      @contents[datetime.strftime('%Y/%m/%d')] = radios
    end
  end
end
