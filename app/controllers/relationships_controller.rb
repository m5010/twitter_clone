class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end

  private
    def logged_in_user
      unless logged_in?
        redirect_to user, danger: "Please log in."
      end
    end
end
