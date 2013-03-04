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
    Bid.where('twitter_verified_user_id = ?', self.twitter_id).maximum('amount').to_s
  end

  def set_data
    json = JSON.parse(data)
    self.name = json['name'].strip
    self.screen_name = json['screen_name'].strip
    self.profile_image_url = json['profile_image_url'].strip
    self.followers_count = json['followers_count'].to_i
    save!
  end
end
