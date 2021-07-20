class MapsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    results = Geocoder.search(@event.location) # viewで得た:addressをresultに変数に代入
    @latlng = results.first.coordinates # resultで得た情報をもとに緯度経度を取得する。
  end

  def map
    results = Geocoder.search(params[:location]) # viewで得た:addressをresultに変数に代入
    @latlng = results.first.coordinates # resultで得た情報をもとに緯度経度を取得する。

    respond_to do |format|
      format.js
    end
  end
end
