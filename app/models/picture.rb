module DoggieSite
  class Picture
    include DataMapper::Resource

    property :id,           Serial
    property :path,         String

    belongs_to :dog
  end
end
