class Book < ApplicationRecord
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
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :star,presence:true
 
  scope :latest, -> {order(created_at: :desc)} 
  # scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
# order・・・データの取り出し
# Latest・・・任意の名前で定義する
# order(created_at: :desc)
# created_at・・・投稿日のカラム
# desc・・・昇順
# asc・・・降順
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
