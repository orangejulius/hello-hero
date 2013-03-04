class BlacklistController < ApplicationController
  def blacklist
    if current_user.admin?
      Blacklist.create(twitter_verified_user: TwitterVerifiedUser.find_by_screen_name(params[:screen_name]))
    end
    redirect_to root_path
  end
end
