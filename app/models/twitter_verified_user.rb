class TwitterVerifiedUser < ActiveRecord::Base
  attr_accessible :data, :twitter_id, :profile_image_url, :screen_name, :name

  def highest_bid
  end
end
