応用課題フェーズ
* 課題7b グループ作成機能
* 課題8b グループ入退会機能
* 課題9b グループメール機能

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜課題7b グループ機能〜〜〜
* グループコントローラ作成 =>rails g controller groups

* グループモデル作成
rails g model Group name:string introduction:text image_id:string owner_id:integer
グループユーザーモデル作成(foreign_key: trueも記述)
rails g model GroupUser user_id:integer group_id:integer => rails db:migrate

* アソシエーション設定
group-userモデル => belogs_to:user, belongs_to:group
groupモデル => has_many:group_users , has_many :users , through :group_users （group_usersを経由してgroupの情報を得る）
userモデル => has_many :group_users , has_many:groups , through :users （group_usersを経由してuserの情報を得る）

* routes設定
resources :groups, except: [:destroy] (destroyは省く) == only: [:index, :show, :edit, :create, :update, :new, :show]こっちでもよい

* 各種Viewページの作成