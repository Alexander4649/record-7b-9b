応用課題フェーズ
* 課題7b 投稿数掲載
* 課題8b 投稿数一覧・グラフ化
* 課題9b 指定日の投稿数を非同期通信化表示

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜課題7b 投稿数掲載〜〜〜
* 投稿数をカウントする => <%= current_user.books.where('created_at > ?', Date.today).count %>
current_user：deviseを使用しているのでそのまま使います
books：アソシエーションを組んでいるので「現在のユーザーが投稿した本」になります
where：whereの使い方はこちら
'created_at > ?': usersカラムにて生成される記述を引用。これでuserがcreateした記録をとっているはず
Date.today:「今日」を表しているクラスです。Date.newで週、月、年を表示できます。
.count：これが数を数ええるメソッドです。

〜〜〜上だとできなかったので〜〜〜
* bookモデルに
# 投稿数設定 => users_controllerにて使用
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } 
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } 
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
~~
* Userコントローラに
 @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
~~
* Viewに
<tr>
      <td><%= @today_book.count %></td>
      <td><%= @yesterday_book.count %></td>
      <% if @yesterday_book.count == 0 %>
      <%# if @today_book.count == 0 %>
        <td> 0 % </td>
      <% else %>
        <td><%= @the_day_before = @today_book.count / @yesterday_book.count.to_f  %>
          <%#= @the_day_before = @yesterday_book.count / @today_book.count %>
       　  <%= (@the_day_before * 100).round %>%</td>
      <% end %></td>
    </tr>


<tr>
      <td><%= @this_week_book.count %></td>
      <td><%= @last_week_book.count %></td>
     <% if @last_week_book.count == 0 %>
      <td> 0 % </td>
     <% else %>
       <td><% @the_week_before = @this_week_book.count / @last_week_book.count.to_f %>
           <%= (@the_week_before * 100).round %>%</td>
     <% end %>
    </tr>

~テーブルに枠線をつける~
<table class='table table-bordered'>