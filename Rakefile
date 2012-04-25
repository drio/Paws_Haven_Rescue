require 'rubygems'
require 'rake'
require 'aws/s3'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

require 'boot'

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./app/boot"
end

desc "Setup S3 environment"
task :s3_setup do
  bucket_name = DoggieSite::Config::AMAZON_S3_BUCKET
  DoggieSite::S3::connect()
  AWS::S3::Bucket.create(bucket_name)
end

desc "Clean all the data in S3 bucket"
task :s3_clean do
  bucket_name = DoggieSite::Config::AMAZON_S3_BUCKET
  DoggieSite::S3::connect()
  AWS::S3::Bucket.delete(bucket_name, :force => true)
end

desc "remove db"
task :rm_db do
  sh "rm -f *.db"
end

desc "Set ENV vars in heroku"
task :heroku_settings do
  key_vars = ""
  File.open("app/scripts/env_vars.sh", "r").each_line do |l|
    next unless l =~ /^export/
    dev_null, key_value = l.split
    key, value = key_value.split("=")
    value.gsub!(/\"/, '')
    key_vars += "#{key}=#{value} "
  end
  puts "heroku config:add #{key_vars}"
end

desc "star_fresh: database and s3 bucket and start fresh"
task :fresh => [:s3_clean, :rm_db, :s3_setup] do
  puts "Ready to start fresh ..."
end



