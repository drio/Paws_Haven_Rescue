module DoggieSite
  class App < Sinatra::Base

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :views, Proc.new { File.join(root, "/backend/views") }
    set :layout, true
    set :method_override, true

    set :s3_id , ENV['AMAZON_ACCESS_KEY_ID']
    set :s3_key, ENV['AMAZON_SECRET_ACCESS_KEY']

    # login/pwd for the backend (DS : DoggieSite)
    set :username, ENV['DS_USERNAME']
    set :password, ENV['DS_PASSWORD']
    set :token   , ENV['DS_TOKEN']

    helpers do
      def admin?     ; request.cookies[settings.username] == settings.token ; end
      def protected! ; redirect '/admin' unless admin?         ; end
    end
  end
end
