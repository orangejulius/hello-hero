desc "add new ids from the list of verified users"
task :get_verified_users => :environment do |t, args|
  next_cursor = -1
  count = args[:count]
  count ||= 100
  begin
    begin
      puts "on cursor: #{next_cursor}"
      cursor = Twitter.friend_ids('verified', next_cursor: next_cursor, count: count)
      cursor.collection.each do |id|
        user = TwitterVerifiedUser.find_by_twitter_id(id)
        TwitterVerifiedUser.create(twitter_id: id) unless user
      end
      next_cursor = cursor.next
    end while next_cursor != 0
  rescue Twitter::Error::TooManyRequests => error
    puts "#{Time.now}: sleeping until #{error.rate_limit.reset_at} (#{error.rate_limit.reset_in} seconds)"
    sleep error.rate_limit.reset_in
    retry
  end
end
