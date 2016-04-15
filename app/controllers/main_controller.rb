class MainController < ApplicationController

  # 一週間分のラジオを表示する
  def index
    num = params[:num] || 1
    num = num.to_i - 1
    @next = num + 2

    @contents = {}
    weeks = %w(Sun Mon Tue Wed Thu Fri Sat)
    for i in (num * 7)..(num * 7 + 6)
      datetime = DateTime.now - i.day
      radios = Radio.includes(:radio_station).references(:radio_stations).order(published_at: :desc)
        .where('published_at BETWEEN ? AND ?', datetime.beginning_of_day, datetime.end_of_day).all
      next if radios.length == 0

      key = datetime.strftime('%Y/%m/%d') + ' ' + weeks[datetime.strftime('%w').to_i]
      @contents[key] = radios
    end
  end
end
