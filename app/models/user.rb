class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # has_many :messages, dependent: :destroy
  # has_many :entries, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :group_users
  has_many :groups,through: :group_users
  
  #1 フォローされる側なのか、フォローする側かのhas_manyかわからないので、foreign_keyを設定してフォローする側からのhas_manyだと認識させてあげる
  has_many :relationships, class_name: "Relationship",foreign_key: :following_id, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  #1とは逆にフォローされる側からのhas_manyだと認識させてあげるが、relationshipsと記述すると、フォローする側のアソシエーションと重複してしまうので、reverse_of_を使用する
  #但し、reverse_of_relationshipsのテーブルを見つけようとするので、class_nameを使ってrelationshipテーブルであると認識させる。
  
  #フォローしている人全員の情報を取得するので、任意名ですが、followingsと記述
  #has_many_throughにて中間テーブルを経由して情報を持ってくる際に使用する。その為、今回はrelationshipsと記述
  #relationshipsから何の情報をとってくるのか、これを指定する際にsourceを使用する
  #あるアカウントがフォローしている情報をリレーションシップの中間テーブルを経由してフォローされる側の情報を抽出するという記述の意味となる。
  has_many :followings, through: :relationships, source: :follower
  has_many :followers, through: :reverse_of_relationships, source: :following
  #あるユーザーをフォローしてくれている人を抽出する
  #自分をフォローしてくれる人の情報を全部取ってくる記述なので、source: :followingとなる
  
  #あるユーザが引数で渡されたUserにフォローされているのか否か判定できるメソッド
  def followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present?
  end
  
  # # フォローしたときの処理
  # def follow(user_id)
  # relationships.create(follower_id: user_id)
  # end
  # # フォローを外すときの処理
  # def unfollow(user_id)
  # relationships.find_by(follower_id: user_id).destroy
  # end
  # # フォローしているか判定
  # def following?(user)
  # followings.include?(user)
  # end
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  
   scope :created_at, -> (created_at) { where('created_at LIKE ?', "%#{created_at}%") if created_at.present? }  #scopeを定義。
  
  
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
