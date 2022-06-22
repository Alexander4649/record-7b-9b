class BooksController < ApplicationController
  before_action :authenticate_user! #ログイン中か確認
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] #ログイン中のユーザーにのみ、機能させるアクション指定

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
   if params[:latest]
      @books = Book.latest
  # elsif params[:old]
  #     @books = Book.old
   elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
   end
      @book = Book.new
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
