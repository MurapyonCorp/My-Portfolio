class MapsController < ApplicationController
  
  def index
  end
  
  def map
    results = Geocoder.search(params[:address]) #viewで得た:addressをresultに変数に代入
    @latlng = results.first.coordinates  #resultで得た情報をもとに緯度経度を取得する。
    
      respond_to do |format|
        format.js
      end
  end
end
