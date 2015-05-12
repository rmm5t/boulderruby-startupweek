source "https://rubygems.org"

ruby IO.read(File.expand_path("../.ruby-version", __FILE__)).chomp

group :development do
  gem "guard"
  gem "guard-shell"
end

group :cloudinary do
  gem "actionview", require: "action_view"
  gem "cloudinary"
end

group :pusher do
  gem "guard-coffeescript"
  gem "sinatra"
  gem "pusher"
end
