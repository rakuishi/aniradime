class FeedController < ApplicationController
  def index
    @radios = Radio.includes(:radio_station).references(:radio_stations)
      .order(published_at: :desc).take(25)

    respond_to do |format|
      format.atom
    end
  end
end
