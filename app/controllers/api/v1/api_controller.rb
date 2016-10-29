require 'digest/md5'

module Api
  module V1
    class ApiController < ApplicationController
      def get_feeds
        json = Radio.all_to_json(params[:offset] ||= 0, params[:limit] ||= 24)
        render :json => json, :status => 200
      end
    end
  end
end
