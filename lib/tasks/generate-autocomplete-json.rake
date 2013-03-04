def truncate(input)
  return nil if input.nil?
  out = input[0..100]
  out += '...' if out.length > 100
  out
end

desc "generate json for use by typeahead.js"
task :make_json => :environment do |t|
  limit = ENV['limit'] || 25000
  offset = ENV['offset'] || 0
  filename = ENV['filename'] || 'public/twitter.json'
  out = []
  TwitterVerifiedUser.where("data != ''").order('followers_count DESC').limit(limit).offset(offset).each do |user|
    data_json = JSON.parse(user.data)
    out_json = { screen_name: user.screen_name,
      value: user.name,
      img: user.profile_image_url,
      description: truncate(data_json['description']),
      tokens: ([user.screen_name] + user.name.split).uniq }
    out.append out_json
  end

  File.open(filename, 'w') do |f|
    f.write(out.to_json)
  end
end
