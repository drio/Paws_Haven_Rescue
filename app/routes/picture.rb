module DoggieSite
  class App < Sinatra::Base
    # VIEWS for pictures

    # Entry point for new picture
    get '/picture/:id/new' do
      @dog = Dog.get(params[:id])
      haml :"pictures/new"
    end

    # Actually create new task
    post '/picture/create' do
      # Make sure we have a file to work with
      unless params[:file] &&
             (tmpfile = params[:file][:tempfile]) &&
             (name = params[:file][:filename])
        redirect "/picture/#{params[:dog_id]}/new"
      end

      bucket_name = DoggieSite::Config::AMAZON_S3_BUCKET
      DoggieSite::S3::connect()
      AWS::S3::S3Object.store(name,
                              open(tmpfile),
                              bucket_name,
                              :access => :public_read)
      url = "https://s3.amazonaws.com/#{bucket_name}/#{name}"

      picture                 = Picture.new
      picture.name            = name
      picture.s3_original_url = url
      picture.save
      dog = Dog.first(:id => params[:dog_id])
      dog.pictures << picture
      dog.save

      "You added dog with id: #{params[:dog_id]}" +
      "<br>" +
      "<img src='https://s3.amazonaws.com/#{bucket_name}/#{name}' height='200' width='200'>" +
      "<a href='/dogs'>back to dogs</a>"
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
