class Book < ApplicationRecord
  # 閲覧数設定 gem適用 =>showアクションにつながる
  is_impressionable
  
  # アソシエーション設定
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  # nameは検索対象であるusersテーブル内のカラム名
  # titleは検索対象であるbooksテーブル内のカラム名
  
  # def self.last_week # メソッド名は何でも良いです
  # Book.joins(:favorites).where(favorites: { created_at:　0.days.ago.prev_week..0.days.ago.prev_week(:sunday)}).group(:id).reorder("count(*) desc")
  # end
  
  # バリデーション設定
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :star,presence:true
 
# 並び順設定
  scope :latest, -> {order(created_at: :desc)} 
  # scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
# order・・・データの取り出し
# Latest・・・任意の名前で定義する
# order(created_at: :desc)
# created_at・・・投稿日のカラム
# desc・・・昇順
# asc・・・降順

# 投稿数設定 => users_controllerにて
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } 
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } 
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
  
# イイね機能設定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
