require 'json'
require_relative '../config/environment.rb'

items = 100
if ARGV.length >= 1
  items = ARGV[0]
end

out = []
TwitterVerifiedUser.where("data != ''").order('followers_count DESC').limit(items).each do |user|
  out_json = { screen_name: user.screen_name,
   # profile_image_url: user.profile_image_url,
    value: user.name,
    tokens: ([user.screen_name] + user.name.split).uniq }
  out.append out_json
end

puts out.to_json
