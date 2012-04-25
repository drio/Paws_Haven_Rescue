module DoggieSite
  class App < Sinatra::Base
    # VIEWS for pictures

    # Entry point for new picture
    get '/picture/:id/new' do
      protected!
      @dog = Dog.get(params[:id])
      haml :"pictures/new"
    end

    # Actually create new task
    post '/picture/create' do
      protected!
      # Make sure we have a file to work with
      unless params[:file] &&
             (tmpfile = params[:file][:tempfile]) &&
             (name = params[:file][:filename])
        # TODO: pass info so the user know you need a file
        redirect "/picture/#{params[:dog_id]}/new"
      end

      # Dump the new pictures in the bucket
      obj_name    = "#{params[:dog_id]}_#{name}"
      bucket_name = DoggieSite::Config::AMAZON_S3_BUCKET
      DoggieSite::S3::connect()
      AWS::S3::S3Object.store(obj_name,
                              open(tmpfile),
                              bucket_name,
                              :access => :public_read)
      url = "https://s3.amazonaws.com/#{bucket_name}/#{obj_name}"

      # Save image info in the database and link to dog
      picture                 = Picture.new
      picture.name            = name
      picture.s3_obj_name     = obj_name
      picture.s3_original_url = url
      unless picture.save
        "DRD>> Problems saving the picture in DB. Details follow:"
        picture.errors.each {|e| puts ">> #{e}"}
      end

      dog = Dog.first(:id => params[:dog_id])
      dog.pictures << picture
      puts "DRD>> Problems dog after adding new picture to DB" unless dog.save

      redirect '/dogs'
      #"You added a picture for dog with id: #{params[:dog_id]} <br>" +
      #"Now #{dog.name} has #{dog.pictures.size} pictures.<br>" +
      #"<br>" +
      #"<img src='#{url}' height='200' width='200'>" +
      #"<a href='/dogs'>back to dogs</a>"
    end

    ## delete confirmation
    get '/picture/:id/delete' do
      protected!
      @picture = Picture.get(params[:id])
      haml :"pictures/delete"
    end

    ## delete task
    delete '/picture/:id' do
      protected!
      s3_obj_name = Picture.first(:id => params[:id]).s3_obj_name
      Picture.get(params[:id]).destroy

      # Dump the new pictures in the bucket
      DoggieSite::S3::connect()
      AWS::S3::S3Object.delete(s3_obj_name, DoggieSite::Config::AMAZON_S3_BUCKET)

      redirect '/dogs'
    end
  end
end
