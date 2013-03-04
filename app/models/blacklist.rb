class Blacklist < ActiveRecord::Base
  attr_accessible :twitter_verified_user
  belongs_to :twitter_verified_user
end
