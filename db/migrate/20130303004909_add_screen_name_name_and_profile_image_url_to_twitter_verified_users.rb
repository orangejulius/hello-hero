class AddScreenNameNameAndProfileImageUrlToTwitterVerifiedUsers < ActiveRecord::Migration
  def change
    add_column :twitter_verified_users, :name, :string
    add_column :twitter_verified_users, :screen_name, :string
    add_column :twitter_verified_users, :profile_image_url, :string
    TwitterVerifiedUser.where("data != ''").each do |user|
      json = JSON.parse(user.data)

      user.screen_name = json['screen_name']
      user.name = json['name']
      user.profile_image_url = json['profile_image_url']
      user.save!
    end
  end
end
