$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Dependencies
require 'rubygems'
require 'sinatra/base'
require 'data_mapper'

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

# Non-autoloaded views
#require_relative 'views/layout'
#require_relative 'views/aggregate'
#require_relative 'views/project'

# Extensions
#require_relative '../lib/ext/array'

# Add some useful methods to the namespace of the app
module DoggieSite
  # The temporary directory that we can extract downloads to.
  #
  # Returns a relative String path.
  def self.temp_dir
    'tmp'
  end

  # The redis namespace to put everything else under.
  #
  # Returns a String.
  def self.redis_namespace
    "hopper"
  end
end