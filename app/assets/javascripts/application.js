// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

//= require jquery
//= require moment
//= require fullcalendar
var element = ''
$(function () {
    // 画面遷移を検知
    $(document).on('turbolinks:load', function () {
        element = '';
        var json_url = ''
        // .lengthはそれが存在するか、（直前のIDが）何個あるか？というチェックをしている。events_controllerからのデータであれば直下のif文が呼び出される。
        if ( $('#events_calendar').length){
            element = '#events_calendar';
            json_url = '/events.json';
        }
        // tasks_controllerからのデータであれば直下のif文が呼び出される。
        if ( $('#tasks_calendar').length){
            element = '#tasks_calendar';
            json_url = '/tasks.json';
        }
        // 上記で呼び出された変数を元にelementにevent or taskのカレンダーが代入されるかつデータも分岐する。
        if ($(element).length) {
            console.log('events');
            function Calendar() {
                return $(element).fullCalendar({
                });
            }
            function clearCalendar() {
                $(element).html('');
            }

            $(document).on('turbolinks:load', function () {
                Calendar();
            });
            $(document).on('turbolinks:before-cache', clearCalendar);

            //events: '/events.json', 以下に追加
            $(element).fullCalendar({
              googleCalendarApiKey: gon.g_key,
              googleCalendarId: 'ja.japanese#holiday@group.v.calendar.google.com',
                events: json_url,
                //カレンダー上部を年月で表示させる
                titleFormat: 'YYYY年 M月',
                //曜日を日本語表示
                dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
                //ボタンのレイアウト
                header: {
                    left: 'today prev,next',
                    center: 'title',
                    right: ''
                },
                //終了時刻がないイベントの表示間隔
                defaultTimedEventDuration: '03:00:00',
                buttonText: {
                    prev: '前',
                    next: '次',
                    prevYear: '前年',
                    nextYear: '翌年',
                    today: '今日',
                    month: '月',
                    week: '週',
                    day: '日'
                },
                // Drag & Drop & Resize
                editable: true,
                //イベントの時間表示を２４時間に
                timeFormat: "HH:mm",
                //イベントの色を変える
                eventColor: '#87cefa',
                //イベントの文字色を変える
                eventTextColor: '#000000',
                eventRender: function(event, element) {
                    element.css("font-size", "0.8em");
                    element.css("padding", "5px");
                }
            });
            google_cal_load();
        }
    });
});


function google_cal_load(){


    const API_KEY = gon.g_key
    const CALENDAR_ID = 'ja.japanese#holiday@group.v.calendar.google.com';

    function start() {
      gapi.client.init({
        'apiKey': API_KEY,
      }).then(function() {
        return gapi.client.request({
          'path': 'https://www.googleapis.com/calendar/v3/calendars/' + encodeURIComponent(CALENDAR_ID) + '/events'
        })
      }).then(function(response) {

        let items = response.result.items;
        for(let i = 0; i < items.length; i++){
          //console.log('beforeend', items[i].summary + items[i].start.date + '<br>');
          let day = items[i].start.date;
          console.log(day);
          console.log(items[i].summary);
          $(element).fullCalendar('addEventSource', {
            events: [
              {

                title: items[i].summary,
                start: items[i].start.date,
                //rendering: 'background',
                //className: items[i].summary
                //backgroundColor: '',
              }
            ],
            backgroundColor: '#ff0000',
          }

          );


          //if(event.source.googleCalendarId == 'ja.japanese#holiday@group.v.calendar.google.com') {
          //  $('.fc-day-top[data-date=' + event.start._i + ']').css('color', '#FF0066');
          //}
            // }


          $('[data-date=' + items[i].start.date + ']').addClass("fc-holiday");


        }
      }, function(reason) {
        console.log('Error: ' + reason.result.error.message);
      });
    };



    gapi.load('client', start);
  }


  var mapInstance;   //変数を宣言

  function initMap() {  //initMapという関数を定義
    mapInstance = new google.maps.Map(document.getElementById("map"), {   //getElementByIdで指定したIDとマッチするドキュメンを取得するメソッド。
      center: { lat: 35.681236, lng: 139.767125 },  //地図の中央位置を指定。位置座標を表すパラメーター(lat:緯度、lng:経度)
      zoom: 15, //15がおすすめかもしれない  ///数字で地図の拡大範囲を表す
    });
  }