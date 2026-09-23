class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      flash[:alert] = "Check the comment form, something went wrong."
      redirect_to root_path
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    unless owned_comment?
      flash[:alert] = "That comment doesn't belong to you!"
      redirect_to root_path
      return
    end

    @comment.delete
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private def comment_params
    params.require(:comment).permit(:content)
  end

  private def set_post
    @post = Post.find(params[:post_id])
  end

  private def owned_comment?
    @comment.user_id == current_user.id
  end

end
