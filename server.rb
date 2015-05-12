require "bundler/setup"
Bundler.require(:pusher)
require "yaml"

# Pusher configured via ENV["PUSHER_URL"]

set :public_folder, "./"

get "/" do
  File.read("pusher.html")
end

post "/pusher/auth" do
  content_type :json
  Pusher[params[:channel_name]].authenticate(params[:socket_id]).to_json
end

get "/pusher/config.js" do
  content_type :js
  "window.pusher = new Pusher('#{Pusher.default_client.key}')"
end
