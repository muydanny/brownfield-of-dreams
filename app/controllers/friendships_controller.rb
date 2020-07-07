class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.friendships.create(:friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = 'Friend added!'
      redirect_to '/dashboard'
    else
      flash[:error] = 'Unable to add friend :( '
      redirect_to '/dashboard'
    end
  end

  def destroy
    
  end

end