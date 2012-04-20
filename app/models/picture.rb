module DoggieSite
  class Picture
    include DataMapper::Resource

    property :id,              Serial
    property :name,            String
    property :s3_obj_name,     String
    property :s3_original_url, String

    belongs_to :dog
  end
end
