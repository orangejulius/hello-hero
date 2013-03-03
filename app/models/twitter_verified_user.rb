class TwitterVerifiedUser < ActiveRecord::Base
  attr_accessible :data, :twitter_id, :profile_image_url, :screen_name, :name

  has_many :bids
  has_many :users, through: :bids

  def big_profile_image_url
    profile_image_url.sub('normal', 'bigger')
  end

  def mini_profile_image_url
    profile_image_url.sub('normal', 'mini')
  end

  def original_profile_image_url
    profile_image_url.sub('_normal', '')
  end

  def highest_bid
  end
end
