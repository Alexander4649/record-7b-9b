class Relationship < ApplicationRecord
  #実際にfollwingとfollwerテーブルは存在しないので、userテーブルを参照してもらう為に、class_nameを記述する 
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"
  
end
