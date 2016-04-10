class MainController < ApplicationController
  def index
    @radios = Radio.includes(:radio_station).references(:radio_stations).order(published_at: :desc).limit(24)
  end
end
