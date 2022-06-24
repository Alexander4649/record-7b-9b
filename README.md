応用課題フェーズ
* 課題7a 合計カウント順
* 課題8a DM機能(相互フォロー限定)
* 課題9a ページアクセス機能

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜課題9a ページアクセス機能〜〜〜
gem 'impressionist'=> gemファイルに追記しbundle

imperssionsテーブルを作る
rails g impressionist => migrate

tweets_controller.rb の中で、動かしたいアクションに対して impressionist というアクションを追加します。
例えば、ある特定のツイートを誰かが押して、詳細をみた際にPV数を計測したい場合は以下のように、showアクションに impressionist をつけます。
PV数は様々な方法で計測することができますが、今回は同じ人アクセス（同じブラウザからアクセス）した複数回、同じ記事をみた場合は1PVと数えることにしました。
uniqueでは、どの値で計測するかを書く

impressionist :actions=> [:show]
impressionist(@book, nil, unique: [:session_hash])

計測したいモデルにis_impressionableを記述

実際にブラウザでPV数を確認する
<%=  @tweet.impressionist_count %>