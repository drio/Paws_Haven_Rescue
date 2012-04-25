module DoggieSite
  class App < Sinatra::Base
    get '/admin' do
      haml :"admin/admin"
    end

    post '/login' do
      if params['username'] == settings.username &&
         params['password'] == settings.password
        response.set_cookie(settings.username, settings.token)
        redirect '/dogs'
      else
        haml :"admin/login"
      end
    end

    get('/logout') do
      response.set_cookie(settings.username, false) ; redirect '/'
    end
  end
end
