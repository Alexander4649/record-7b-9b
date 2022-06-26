応用課題フェーズ
* 課題7b 投稿数掲載
* 課題8b 投稿数一覧・グラフ化
* 課題9b 指定日の投稿数を非同期通信化表示

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜課題8b 投稿数グラフ化〜〜〜

* gemインストール
gem 'chartkick'
gem 'groupdate' 追記 => bundle

* application.jsファイルに追記
import Chart from 'chart.js/auto';
import jQuery from "jquery"
global.$ = jQuery;
window.$ = jQuery;
global.Chart = Chart;

* Turbolinksの無効化 (showに記述すれば編集する必要なし)
application.jsファイル編集
gemfile編集
application.html.erbファイル編集


* book.rb にて2日〜6日前の投稿データを取得する為の記述
 scope :created_2days, -> { where(created_at: 2.days.ago.all_day) } 
 scope :created_3days, -> { where(created_at: 3.days.ago.all_day) } 
 scope :created_4days, -> { where(created_at: 4.days.ago.all_day) } 
 scope :created_5days, -> { where(created_at: 5.days.ago.all_day) } 
 scope :created_6days, -> { where(created_at: 6.days.ago.all_day) } 

* Viweにて表と折線グラフの記述

〜表〜
<table class='table table-bordered'>
    <th>6日前</th>
    <th>5日前</th>
    <th>4日前</th>
    <th>3日前</th>
    <th>2日前</th>
    <th>1日前</th>
    <th>今日</th>
     <tr>
       <th><%= @books.created_6days.count %></th>
       <th><%= @books.created_5days.count %></th>
       <th><%= @books.created_4days.count %></th>
       <th><%= @books.created_3days.count %></th>
       <th><%= @books.created_2days.count %></th>
       <th><%= @yesterday_book.count %></th>
       <th><%= @today_book.count %></th>
     </tr>
  </table>
  
〜折線〜

* turbolinks部分削除

 <canvas id="myLineChart"></canvas>
  <script>
      $(document).on('turbolinks:load', function() {
      var ctx = document.getElementById("myLineChart");
      var myLineChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['6日前', '5日前', '4日前', '3日前', '2日前', '1日前', '今日'],
          datasets: [
            {
              label: '投稿した本の数',
              data: [<%= @books.created_6days.count %>, <%= @books.created_5days.count %>, <%= @books.created_4days.count %>, <%= @books.created_3days.count %>, <%= @books.created_2days.count %>, <%= @yesterday_book.count %>, <%= @today_book.count%>],
              borderColor: "rgba(0,0,255,1)",
              backgroundColor: "rgba(0,0,0,0)"
            }
          ],
        },
        options: {
          title: {
            display: true,
            text: '7日間の投稿数の比較'
          },
          scales: {
            yAxes: [{
              ticks: {
                suggestedMax: 10,
                suggestedMin: 0,
                stepSize: 1,
                callback: function(value, index, values){
                  return  value
                }
              }
            }]
          },
        }
      });
    });
  </script>
  
* turbolinks全削除での記述

<canvas id="myChart" width="300" height="100"> </canvas>

    <script> 
    var ctx = document.getElementById("myChart").getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'line',                      
        data: {
            labels: ['6日前', '5日前', '4日前', '3日前', '2日前', '1日前', '今日'],
            datasets: [{
                label: "投稿数",
                data: [<%= @books.created_6days.count %>, <%= @books.created_5days.count %>, <%= @books.created_4days.count %>, <%= @books.created_3days.count %>, <%= @books.created_2days.count %>, <%= @yesterday_book.count %>, <%= @today_book.count%>],
                backgroundColor: 'rgba(255, 80, 120, 1.0)',
                borderColor: 'rgba(255, 80, 120, 1.0)',
                fill: false
            }]
        },
    });
</script>

〜〜〜回答の例〜〜〜
  <canvas id="myLineChart"></canvas>
  <script>
    $(document).on('turbolinks:load', function() {
      var ctx = document.getElementById("myLineChart");
      var myLineChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['6日前', '5日前', '4日前', '3日前', '2日前', '1日前', '今日'],
          datasets: [
            {
              label: '投稿した本の数',
              data: [
                <%= @books.created_6days.count %>,
                <%= @books.created_5days.count %>, 
                <%= @books.created_4days.count %>, 
                <%= @books.created_3days.count %>, 
                <%= @books.created_2days.count %>, 
                <%= @books.created_yesterday.count %>, 
                <%= @books.created_today.count %>
              ],
              borderColor: "rgba(0,0,255,1)",
              backgroundColor: "rgba(0,0,0,0)",
              tension: 0.4
            }
          ],
        },
        options: {
          title: {
            display: true,
            text: '7日間の投稿数の比較'
          },
          responsive: true,
          scales: {
            y:{
              suggestedMin: 0,
              suggestedMax: 10
            },
            x:{
              stacked: true
            },
          },
        }
      });
    });
  </script>