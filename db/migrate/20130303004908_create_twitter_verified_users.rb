class CreateTwitterVerifiedUsers < ActiveRecord::Migration
  def change
    create_table :twitter_verified_users do |t|
      t.integer :twitter_id
      t.text :data
    end
  end
end
