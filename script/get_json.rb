require 'json'
require_relative '../config/environment.rb'

items = 100
if ARGV.length >= 1
  items = ARGV[0]
end

out = []
TwitterVerifiedUser.where("data != ''").limit(items).each do |user|
  out_json = { name: user.name, screen_name: user.screen_name, profile_image_url: user.profile_image_url,
    tokens: [user.screen_name] + user.name.split }
  out.append out_json
end

puts out.to_json
