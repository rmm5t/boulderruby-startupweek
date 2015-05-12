require "bundler/setup"
Bundler.require(:pusher)
require "yaml"

set :public_folder, "./"

get "/" do
  File.read("pusher.html")
end

post "/pusher/auth" do
  content_type :json
  Pusher[params[:channel_name]].authenticate(params[:socket_id]).to_json
end

get "/config.js" do
  content_type :js
  <<-EOF
    window.pusher = new Pusher("#{Pusher.default_client.key}");
    jQuery.embedly.defaults.key = "#{ENV["EMBEDLY_KEY"]}";
  EOF
end
