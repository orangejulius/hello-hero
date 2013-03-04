desc "update TwitterVerifiedUser fields from json data"
task :set_data => :environment do |t|
  TwitterVerifiedUser.where("data != ''").each { |user| user.set_data }
end
