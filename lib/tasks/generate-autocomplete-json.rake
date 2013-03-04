def truncate(input)
  return nil if input.nil?
  out = input[0..100]
  out += '...' if out.length > 100
  out
end

desc "generate json for use by typeahead.js"
task :make_json => :environment do |t, args|
  limit = ENV['limit'] || ARGV[1] || 25000
  offset = ENV['offset'] || ARGV[2] || 0
  filename = ENV['filename'] || ARGV[3] || 'public/twitter.json'
  puts "writing #{limit} entries to #{filename} with offset #{offset}"
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

desc "generate both json files for typeahead.js"
task :make_all_json => :environment do |t|
  ENV['limit'] = 5000.to_s
  Rake::Task[:make_json].execute
  ENV['limit'] = 50000.to_s
  ENV['offset'] = 5000.to_s
  ENV['filename'] = 'public/twitter-big.json'
  Rake::Task[:make_json].execute
end
