class Group < ApplicationRecord
  has_many :group_users
  has_many :users,through: :group_users
  
  
  #あるユーザが引数で渡されたUserがグループに入っているか否かを判定するメソッド
  # def group_join_by?(user)
  #   group_users.find_by(user_id: user.id).present?
  # end
  
  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image
  
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end
end
