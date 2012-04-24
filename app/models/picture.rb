module DoggieSite
  class Picture
    include DataMapper::Resource

    property :id,              Serial
    property :name,            String, :length => 128
    property :s3_obj_name,     String, :length => 128
    property :s3_original_url, String, :length => 128

    belongs_to :dog
  end
end
