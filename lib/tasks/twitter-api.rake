desc "add new ids from the list of verified users"
task :get_verified_users => :environment do |t, args|
  next_cursor = -1
  count = ENV['count'] || 100

  limit = ENV['limit'] || 10000000000
  ids_added = 0
  begin
    begin
      puts "getting up to #{limit} ids in limites of #{count}"
      puts "on cursor: #{next_cursor}"
      cursor = Twitter.friend_ids('verified', cursor: next_cursor, count: count)
      cursor.collection.each do |id|
        ids_added += 1
        user = TwitterVerifiedUser.find_by_twitter_id(id)
        TwitterVerifiedUser.create(twitter_id: id) unless user
      end
      next_cursor = cursor.next
    end while next_cursor != 0 and ids_added < limit.to_i
  rescue Twitter::Error::TooManyRequests => error
    puts "#{Time.now}: sleeping until #{error.rate_limit.reset_at} (#{error.rate_limit.reset_in} seconds)"
    sleep error.rate_limit.reset_in
    retry
  end
end

desc "find user ids in db and get information for them (if it isn't already there)"
task :get_user_info => :environment do |t, args|
  limit = ENV['limit'] || 100

  begin
    results = TwitterVerifiedUser.where(data:nil).limit(limit)
    user_ids = results.map { |result| result[:twitter_id] }

    begin
      users = Twitter.users(user_ids)
    rescue Twitter::Error::TooManyRequests => error
      puts "#{Time.now}: sleeping until #{error.rate_limit.reset_at} (#{error.rate_limit.reset_in} seconds)"
      sleep error.rate_limit.reset_in
      retry
    end
    users.each do |user|
      puts user.name
      data = user.to_hash.to_json
      db_user = TwitterVerifiedUser.find_by_twitter_id(user.id)

      #store all data for potential future use
      db_user.data = data

      #set some known valuable fields
      db_user.name = user.name
      db_user.screen_name = user.screen_name
      db_user.profile_image_url = user.profile_image_url
      db_user.followers_count = user.followers_count
      db_user.save!
    end
  end while results.count > 0
end


desc "show how many rows, and rows with full user data, are in the DB"
task :status => :environment do |t|
  total_rows = TwitterVerifiedUser.count
  partial_rows = TwitterVerifiedUser.where("data != ''").count
	puts "total rows:\t#{total_rows}"
	puts "partial rows:\t#{partial_rows}"
	puts "full rows:\t#{total_rows - partial_rows}"
end
