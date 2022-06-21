class RelationshipsController < ApplicationController
  before_action :authenticate_user!#ログインしているか確認!
  
  def create
    # フォローすることは = ログイン中のユーザーがフォローを行うこと(cuurent_user.relationships.build)、これによりカレントユーザーに紐づいたリレーションシップを作成することができる
    # フォローを行うことはフォローされる側のidが必要になるので、(follwer_id)と記述。follwer_idはパラメータ(URL)から取得する番号である為、params[:user_id]となる。
    # user.rbにてhas_many :relationshipsと記述してあるお陰で、cuurent_userには「following_idが」勝手に入るようになります。
    #following = current_user.followers(@user)
    following = current_user.relationships.new(follower_id:params[:user_id])
    following.save
    redirect_to request.referer || root_path
    
    # current_user.follow(params[:user_id])
    # redirect_to request.referer
  end

  def destroy
    following = current_user.relationships.find_by(follower_id:params[:user_id])
    following.destroy
    redirect_to request.referer || root_path
    
    # current_user.unfollow(params[:user_id])
    # redirect_to request.referer 
  end
  
  #あるユーザーがフォローしている人全員を取得するアクションが必要
  def followings
    # あるユーザーに結びついている(ユーザーがフォローしている)人の情報を全て取得する
    # user.rbにてfollowingsの定義をしている為、使用できる記述
    @user = User.find(params[:user_id])
    #@users = User.all
    @users = @user.followings
    
    # user = User.find(params[:user_id])
    # @users = user.followings
  end
  
  #あるユーザーをフォローしている人全員を取得するアクションが必要
  
  def followers
    # あるユーザーにフォローしている人の情報を全て取得する
    # user.rbにてfollowersの定義をしている為、使用できる記述
    @user = User.find(params[:user_id])
    #@users = User.all
    @users = @user.followers
    # user = User.find(params[:user_id])
    # @users = user.followers
  end
  
end
