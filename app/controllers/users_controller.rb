class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    
    #@books = @user.books.page(params[:page]).reverse_order
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end
  
  def search_form
    
    @user = User.find(params[:user_id])
    @books = @user.books.where(created_at: params[:created_at].to_date.all_day)
    render :search_form
    # if params[:created_at] == ""
    #   @search_book = "日付を選択してください"
    # else
    #   create_at = params[:created_at]
    #   @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    # end
  end



  def index
    @users = User.all
    @book = Book.new
    #@users = User.where.not(id:cuurent_user.id)
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
