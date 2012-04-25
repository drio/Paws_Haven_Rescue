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
  end
end
