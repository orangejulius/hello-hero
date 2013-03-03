class AddFollowersCountToTwitterVerifiedUser < ActiveRecord::Migration
  def change
    add_column :twitter_verified_users, :followers_count, :integer

    TwitterVerifiedUser.where("data != ''").each do |user|
      json = JSON.parse(user.data)

      user.followers_count = json['followers_count']
      user.save!
    end
  end
end
