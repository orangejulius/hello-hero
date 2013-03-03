require 'json'
require_relative '../config/environment.rb'

items = 100
if ARGV.length >= 1
  items = ARGV[0]
end

def truncate(input)
  out = input[0..100]
  out += '...' if out.length > 100
  out
end

out = []
TwitterVerifiedUser.where("data != ''").order('followers_count DESC').limit(items).each do |user|
  data_json = JSON.parse(user.data)
  out_json = { screen_name: user.screen_name,
   # profile_image_url: user.profile_image_url,
    value: user.name,
    img: user.profile_image_url,
    description: truncate(data_json['description']),
    tokens: ([user.screen_name] + user.name.split).uniq }
  out.append out_json
end

puts out.to_json
