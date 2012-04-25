module DoggieSite
  class Dog
    include DataMapper::Resource

    property :id,           Serial
    property :name,         String
    property :adopted,      Boolean
    property :breed,        String
    property :notes,        String, :length => 1024
    property :created_at,   DateTime

    has n, :pictures
  end
end
