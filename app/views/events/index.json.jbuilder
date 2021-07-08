json.array!(@events) do |event|
  json.extract! event, :id, :title, :body, :location
  json.start event.start_date
  json.end event.end_date
  json.url event_url(event, format: :html)
end

#ブラウザで~.com/rails/info/routesと検索すると左側にHelperがあり、そのすぐ下にPath/Urlをクリックできるように
#なっている。このUrlで指定のViewに遷移することが出来る。