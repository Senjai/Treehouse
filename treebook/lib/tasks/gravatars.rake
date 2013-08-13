desc "Import Avatars from a user's gravatar url"
task :import_avatars => :environment do
  puts "Importing avatars from gravatar.."
  User.get_gravatars
  puts "Avatars Updated."
end