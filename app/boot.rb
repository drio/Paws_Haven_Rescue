$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
#$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "routes/dog")

# Dependencies
require 'rubygems'
require 'sinatra/base'
require 'data_mapper'
require 'aws/s3'
require 'json'
require 'dm-serializer'

# Load the App
require 'app'

# Set the DB for datamapper
DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite3://#{Dir.pwd}/development.db")

# Load models
require_relative 'models/dog'
require_relative 'models/picture'

# Tell datamapper to rebuild the DB if changes exist
DataMapper.auto_upgrade!

# Load routes
require_relative 'routes/dog'
require_relative 'routes/picture'

# Add some useful methods to the namespace of the app
module DoggieSite
  module Config
    AMAZON_S3_BUCKET = "doggie_site"
  end

  module S3
    def self.connect()
      AWS::S3::Base.establish_connection!(
        :access_key_id     => DoggieSite::App.settings.s3_id,
        :secret_access_key => DoggieSite::App.settings.s3_key
      )
    end
  end
end
