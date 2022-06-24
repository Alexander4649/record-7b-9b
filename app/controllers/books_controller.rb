class BooksController < ApplicationController
  before_action :authenticate_user! #ログイン中か確認
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] #ログイン中のユーザーにのみ、機能させるアクション指定
  impressionist :actions=> [:show] # showアクションを閲覧した際にgem「impressionist」アクションを使用

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = User.find(user_id)
    impressionist(@book, nil, unique: [:session_hash]) #閲覧カウント(unique)(どの値で計測するかを書く)を同じブラウザからアクセス）した複数回、同じ記事をみた場合は1PVと数える
  end

  def index

   if    params[:latest]
         @books = Book.latest
   elsif params[:star_count]
         @books = Book.star_count
   elsif params[:favorite]
         @books = Book.favorite
   else  @books = Book.find(Favorite.group(:book_id).where(created_at: Time.current.all_week).order('count(book_id) desc').pluck(:book_id))
   
   end
         @book = Book.new
  end
  
# Postモデルから()内のデータを探してくる
# Post.find()
# 次にLikeモデルのpost_idが同じものをまとめる
# Like.group(:post_id)
# #投稿が作られた日が今週のデータのみ抽出
# where(created_at: Time.current.all_week)
# まとめたものをpost_idの多い順に並び替える
# order('count(post_id) desc')
# そのままだとLikeモデルで取り出してしまうので、post_idで値を取りだす
# pluck(:post_id)

# elsif params[:old]
#     @books = Book.old
  
  def weekly_rank
  @books = Book.last_week
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :tag, :star)
  end

  def ensure_correct_user #before_actionによる定義。ログイン中のユーザーを判別する定義
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end