class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.save
    #render :book_comments  #render先にjsファイルを指定
  end
    #@book_comment.save
    #@book = Book.find(params[:id])
    #@book_comment = BookComment.new
    #redirect_to request.referer
    #redirect_back(fallback_location: root_path)

  def destroy
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    #redirect_to request.referer
    @book = Book.find(params[:book_id])  
    #render :book_comments
    #render :destroy
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
