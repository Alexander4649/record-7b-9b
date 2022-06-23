応用課題フェーズ
* 課題7a 合計カウント順
* 課題8a DM機能(相互フォロー限定)
* 課題9a ページアクセス機能

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜〜〜〜〜実際にこれは使えなかった。参考までに〜〜〜〜〜〜
〜〜〜DM機能実装にて必要なモデル作成〜〜〜
* rails g model room user:refarence
* rails g model Entry user:refarence room:refarence
* rails g model message user:refarence room:refarence message:text

〜〜〜アソシエーション設定〜〜〜
Users : Entries = 1 : 多 =>has_many :entries, dependent: :destroy
Users : Messages = 1:多 =>has_many :messages, dependent: :destroy

Entries : User = 多 : 1 =>belongs_to :user
Entries : Rooms = 多 : 1 =>belongs_to :room

Rooms : Entries = 1 : 多 =>has_many :entries, dependent: :destroy
Rooms : Messages = 1 : 多 =>has_many :messages, dependent: :destroy

Messages : Users = 多 : 1 =>belongs_to :user
Messages : Rooms = 多 : 1 =>belongs_to :room

〜〜〜ルーティング設定〜〜〜
resources :users, only: [:show,:edit,:update]
resources :messages, only: [:create]
resources :rooms, only: [:create,:show]
①相互フォローとなったら、相手のusersのshowページで「チャットへ」というボタンを押すことができるようになる。
②押したと同時にroomsがcreateされる
③roomsのshowページに移る
④roomのshowページでmessageがcreateされる

〜〜〜usersコントローラ〜〜〜
 @user=User.find(params[:id])
 @currentUserEntry=Entry.where(user_id: current_user.id)
 @userEntry=Entry.where(user_id: @user.id)
この部分は、showページのために、レコードからユーザー1人1人の情報を持ってくる必要があるため、findメソッドを使っています。
そしてroomがcreateされた時に、現在ログインしているユーザーと、「チャットへ」を押されたユーザーの両方をEntriesテーブルに記録する必要があるので、whereメソッドでそのユーザーを探しているということです。
---
unless @user.id == current_user.id
  @currentUserEntry.each do |cu|
    @userEntry.each do |u|
      if cu.room_id == u.room_id then
        @isRoom = true
        @roomId = cu.room_id
      end
    end
  end
  unless @isRoom
    @room = Room.new
    @entry = Entry.new
  end
end
この部分は、まずはじめに、現在ログインしているユーザーではないというunlessの条件をつけます。
そして、すでにroomsが作成されている場合と作成されていない場合に条件分岐させます。
作成されている場合は、先ほどコードを書いた、 @currentUserEntryと@userEntryをeachで一つずつ取り出し、それぞれEntriesテーブル内にあるroom_idが共通しているのユーザー同士に対して@roomId = cu.room_idという変数を指定します。
これで、すでに作成されているroom_idを特定できるというわけです。
@isRoom=trueと記述したのは、これがfalseの時、つまりはRoomを作成するときの条件を記述するためです。
そのためunless @isRoom内では、新しくインスタンスを生成するために、.newと記載します。

〜〜〜users show〜〜〜
<% unless @user.id == current_user.id %>
  <% if (current_user.followed_by? @user) && (@user.followed_by? current_user)  %>
  <% if @isRoom == true %>
    <p class="user-show-room"><a href="/rooms/<%= @roomId %>" class="btn btn-primary btn-lg">チャットへ</a>
  <% else %>
  <% end %>
  <% end %>
<% end %>
まず、現在ログインしているユーザーではないという条件をつけ、APIのメソッドを使って、相互フォロー状態の時という条件も付け足します。
そしてコントローラーと同様に、すでにチャットルームが作成している時と作成されていない時の条件分岐をさせるため、@isRoomを使用。
@isRoomがtrueの時は、チャットへボタンを出現させ、すでに作成されたチャットへと移行することができます。
---
<%= form_for @room do |f| %>
  <%= fields_for @entry do |e| %>
    <%= e.hidden_field :user_id, value: @user.id %>
  <% end %>
  <%= f.submit "チャットを始める", class:"btn btn-primary btn-lg user-show-chat"%>
<% end %>
falseの場合にはform_forを使って、コントローラにパラメーターを送るための記述をします。
レコードには、親モデルのRoomsテーブルと、子モデルのEntriesテーブル両方に保存する必要があるので、親モデルにform_forインスタンス変数、子モデルにfields_forインスタンス変数とします。
そして、Entriesテーブルのレコードにはuser_idを送る必要があるので、hidden_fieldで@user.idをvalueにおきます。
これで、roomsテーブルに保存されるための準備が整いました。

〜〜〜rooms_controller〜〜〜
def create
  @room = Room.create
  @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
  @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
  redirect_to "/rooms/#{@room.id}"
end
先ほど、users/show.html.erbのform_forの@roomで送られてきたパラメータを、ここで受け取りcreateさせます。
また、このcreateメソッドでは、Room以外にその子モデルのEntryもcreateさせなければいけないので、Entriesテーブルに入る相互フォロー同士のユーザーを保存させるための記述を行います。
まず、現在ログインしているユーザーに対しては、@entry1とし、EntriesテーブルにRoom.createで作成された@roomにひもづくidと、現在ログインしているユーザーのidを保存させる記述をします。
@entry2ではフォローされている側の情報をEntriesテーブルに保存するため。users/show.html.erbのfields_for @entryで保存したparamsの情報(:user_id, :room_id)を許可し、現在ログインしているユーザーと同じく@roomにひもづくidを保存する記述をしています。
そしてcreateと同時に、チャットルームが開くようにredirectをしています。
---
def show
  @room = Room.find(params[:id])
  if Entry.where(user_id: current_user.id,room_id: @room.id).present?
    @messages = @room.messages
    @message = Message.new
    @entries = @room.entries
  else
    redirect_back(fallback_location: root_path)
  end
end
roomsのshowアクションでは、まず１つのチャットルームを表示させる必要があるので、findメソッドを使います。
条件としてはまず、Entriesテーブルに、現在ログインしているユーザーのidとそれにひもづいたチャットルームのidをwhereメソッドで探し、そのレコードがあるか確認します。
もしその条件がfalseだったら、前のページに戻るための記述である、redirect_backを使います。
もしその条件がtrueだったら、Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示させるため、@messagesにアソシエーションを利用した@room.messagesという記述を代入します。
また、新しくメッセージを作成する場合は、メッセージのインスタンスを生成するために、Message.newをし、@messageに代入させます。
そしてrooms/show.html.erbmでユーザーの名前などの情報を表示させるために、@room.entriesを@entriesというインスタンス変数に入れ、Entriesテーブルのuser_idの情報を取得します（ビューの方で記述）。

〜〜〜rooms/show.html.erb〜〜〜
<% @entries.each do |e| %>
  <div class="user-name">
  <strong>
    <%= image_tag e.user.avatar, class:"user-image" %>
      <a class="rooms-user-link" href="/users/<%= e.user.id %>">
        <%= e.user.name %>さん
      </a>
  </strong>
  </div>
<% end %>
前述した@entriesの相互フォロワー同士に情報をとってきたいため、eachでフォロ・フォロワーの情報を取得しています。
そしてEntriesテーブルはアソシエーションを組んでいるので、Entriesテーブルのuser_idのレコードを参照し、Usersテーブルのidとavatarとnameの情報をとってきています。
---
<div class="chat">
  <% if @messages.present? %>
    <% @messages.each do |m| %>
      <div class="chat-box">
        <div class="chat-face">
          <%= image_tag m.user.avatar, class:"user-image" %>
        </div>
        <div class="chat-hukidashi"> <strong><%= m.content %></strong> <br>
          <%= m.created_at.strftime("%Y-%m-%d %H:%M")%>
        </div>
      </div>
    <% end %>
  <% end %>
</div>
メッセージの表示の部分は、rooms_controllerで記述したインスタンス変数@messagesを使い、メッセージが入っているかどうかif文で確認します。
もしメッセージが入っていたら、そのメッセージの情報ごとに表示するため、eachメソッドを使います。
ここでも先ほど同じようにアソシエーションを組んでいるので、Messagesテーブルに紐づいたuser_idから、avatarの情報を表示させます。
また、Messagesテーブルに保存されている、メッセージ内容のcontentカラムの情報と、日本時間を示すcreated_at.strftime("%Y-%m-%d %H:%M")の情報も表示させています。
---
<div class="posts">
  <%= form_for @message do |f| %>
    <%= f.text_field :content, placeholder: "メッセージを入力して下さい" , size: 70, class:"form-text-field" %>
    <%= f.hidden_field :room_id, value: @room.id %>
    <%= f.submit "投稿",class: 'form-submit'%>
  <% end %>
</div>
そして、新しく作成するメッセージを保存させるためにform_forを使って、パラメーターとして送る記述を書きます。
form_forではユーザーが入力したメッセージの内容を取得するため、f.text_field :contentと置いています。
またここでは、どのチャットルームのメッセージが判断するために、f.hidden_fieldで：room_idのバリューとして、そのチャットルームでのidを取得しています。
そしてf.submitとすることで、投稿ボタンが押された時点で、messages_controllerにパラメータが飛んでいきます。

〜〜〜messages_controller〜〜〜
class MessagesController < ApplicationController

  before_action :authenticate_user!, only: [:create]

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id))
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
　　redirect_to "/rooms/#{@message.room_id}"
  end
end
ここではrooms/show.html.erbで送られてきた、form_forのパラメータを実際に保存させるための記述をします。
まず、form_forで送られてきたcontentを含む全てのメッセージの情報の:messageと:room_idのキーがちゃんと入っているかということを条件で確認します。
もしその条件がtrueだったら、メッセージを保存するためにMessage.createとし、Messagesテーブルにuser_id、:content、room_idのパラメーターとして送られてきた値を許可。
メッセージを送ったのは現在ログインしているユーザーなので、そのuser_idの情報をmergeさせます。
そしてその条件がfalseだった場合、フラッシュメーセージを出すための、flash.now[:alert]という記述をします。
最後にredirectで、どちらの条件の場合も元のページへとredirectさせれば完成です。


〜〜〜〜〜〜〜実際にこれは使えなかった。少し古いのかもしれない。参考までに〜〜〜〜〜〜