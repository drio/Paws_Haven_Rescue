module DoggieSite
  class App < Sinatra::Base

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/backend/public"
    set :static, true
    set :views, Proc.new { File.join(root, "/backend/views") }
    set :layout, true
    set :method_override, true
  end
end
