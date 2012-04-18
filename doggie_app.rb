require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite3://#{Dir.pwd}/development.db")

class Dog
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :adopted,     Boolean
  property :created_at,   DateTime

  has n, :pictures
end

class Picture
  include DataMapper::Resource

  property :id,           Serial
  property :path,         String

  belongs_to :dog
end

DataMapper.auto_upgrade!

get '/' do
  "/ is here."
end

# Entry point for new Dog
get '/dog/new' do
  haml "dogs/new"
end

# Actually create new task
post '/dog/create' do
  dog         = Dog.new(:name => params[:name])
  dog.adopted = false
  if dog.save
    status 201
  else
    status 412
  end
  redirect '/dogs'
end

# View a task -- we will see it in /dogs already (no need for this)
# get '/dog/:id' do
#   @dog = Dog.get(params[:id])
#   haml :dog
# end

# list all dogs
get '/dogs' do
  @dogs = Dog.all
  haml :"dogs/index"
end

# edit dog
get '/dog/:id/edit' do
  @dog = Dog.get(params[:id])
  haml :"dogs/edit"
end

# update dog
put '/dog/:id' do
  dog = Dog.get(params[:id])
  #dog.completed_at = params[:completed] ? Time.now : nil
  dog.name    = params[:name]
  dog.adopted = (params[:adopted] == "true" ? true : false)
  if dog.save
    status 201
    #redirect '/dog/' + dog.id.to_s + '/edit'
    redirect '/dogs'
  else
    status 412
    redirect '/dogs'
  end
end

# delete confirmation
get '/dog/:id/delete' do
  @dog = Dog.get(params[:id])
  haml :"dogs/delete"
end

# delete task
delete '/dog/:id' do
  Dog.get(params[:id]).destroy
  redirect '/dogs'
end
