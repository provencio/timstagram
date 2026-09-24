class ReactionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post

  # Sets the signed-in user's reaction to this post, replacing any earlier one.
  def update
    reaction = @post.reactions.find_or_initialize_by(user: current_user)
    reaction.kind = params[:kind]

    if reaction.save
      respond_with_reactions
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @post.reactions.where(user: current_user).destroy_all
    respond_with_reactions
  end

  private def respond_with_reactions
    @post.reactions.reset
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js { render :refresh }
    end
  end

  private def set_post
    @post = Post.find(params[:post_id])
  end

end
