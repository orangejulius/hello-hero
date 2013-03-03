class ChangeProfileImageUrlToText < ActiveRecord::Migration
  def up
    change_table :twitter_verified_users do |t|
      t.change :profile_image_url, :text
    end
  end

  def down
    change_table :twitter_verified_users do |t|
      t.change :profile_image_url, :string
    end
  end
end
