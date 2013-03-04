desc "add new ids from the list of verified users"
task :get_verified_users => :environment do |t, args|
  batch = ENV['batch'] || 5000
  limit = ENV['limit'] || 10000000000

  next_cursor = -1
  ids_added = 0
  puts "getting up to #{limit} ids in batches of #{batch}"
  begin
    begin
      puts "on cursor: #{next_cursor}"
      cursor = Twitter.friend_ids('verified', cursor: next_cursor, count: batch)
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
  batch = ENV['batch'] || 100
  limit = ENV['limit'] || 10000000

  rows_updated = 0

  begin
    results = TwitterVerifiedUser.where(data:nil).limit(batch)
    user_ids = results.map { |result| result[:twitter_id] }

    begin
      users = Twitter.users(user_ids)
      users.each do |user|
        puts user.name
        data = user.to_hash.to_json
        db_user = TwitterVerifiedUser.find_by_twitter_id(user.id)

        #store all data for potential future use
        db_user.data = data
        db_user.save!
        rows_updated += 1
      end
    rescue Twitter::Error::TooManyRequests => error
      puts "#{Time.now}: sleeping until #{error.rate_limit.reset_at} (#{error.rate_limit.reset_in} seconds)"
      sleep error.rate_limit.reset_in
      retry
    rescue Twitter::Error::NotFound => e
      if batch.to_i == 1
        t = TwitterVerifiedUser.find_by_twitter_id(user_ids.first)
        puts "deleting invalid user #{t.twitter_id}"
        t.destroy
      else
        puts "Invalid user found: retry with batch=1 to remove"
        exit
      end
    end
  end while results.count > 0 and rows_updated < limit.to_i
  puts "updated #{rows_updated} rows"
end

desc "add users from a file"
task :add_users => :environment do |t|
  filename = ENV['filename']
  puts filename
  File.open(filename).each do |line|
    user = Twitter.user(line)
    puts user.name
    db_user = TwitterVerifiedUser.new
    db_user.twitter_id = user.id
    db_user.data = user.to_hash.to_json
    db_user.set_data
    db_user.save!
  end
end

desc "show how many rows, and rows with full user data, are in the DB"
task :status => :environment do |t|
  total_rows = TwitterVerifiedUser.count
  full_rows = TwitterVerifiedUser.where("data != ''").count
	puts "total rows:\t#{total_rows}"
	puts "partial rows:\t#{total_rows - full_rows}"
	puts "full rows:\t#{full_rows}"
end
