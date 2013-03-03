class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :user
      t.references :twitter_verified_user
      t.decimal :amount, precision: 12, scale: 2

      t.timestamps
    end
  end
end
