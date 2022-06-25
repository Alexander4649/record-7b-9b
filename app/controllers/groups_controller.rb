class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @user =User.find(user_id)
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
  end
  
  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user #@group.usersに、current_userを追加しているということ
    redirect_to  groups_path
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.users.destroy(current_user)#current_userは、@group.usersから消されるという記述。
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
