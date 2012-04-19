module DoggieSite
  class App < Sinatra::Base
    # VIEWS for pictures

    # Entry point for new picture
    get '/picture/new' do
      haml :"pictures/new"
    end

    # Actually create new task
    post '/picture/create' do
      picture         = picture.new(:name => params[:name])
      picture.adopted = false
      if picture.save
        status 201
      else
        status 412
      end
      redirect '/pictures'
    end

    # list all pictures
    #get '/pictures' do
    #  @pictures = picture.all
    #  haml :"pictures/index"
    #end

    ## edit picture
    #get '/picture/:id/edit' do
    #  @picture = picture.get(params[:id])
    #  haml :"pictures/edit"
    #end

    ## update picture
    #put '/picture/:id' do
    #  picture = picture.get(params[:id])
    #  #picture.completed_at = params[:completed] ? Time.now : nil
    #  picture.name    = params[:name]
    #  picture.adopted = (params[:adopted] == "true" ? true : false)
    #  if picture.save
    #    status 201
    #    #redirect '/picture/' + picture.id.to_s + '/edit'
    #    redirect '/pictures'
    #  else
    #    status 412
    #    redirect '/pictures'
    #  end
    #end

    ## delete confirmation
    #get '/picture/:id/delete' do
    #  @picture = picture.get(params[:id])
    #  haml :"pictures/delete"
    #end

    ## delete task
    #delete '/picture/:id' do
    #  picture.get(params[:id]).destroy
    #  redirect '/pictures'
    #end
  end
end
