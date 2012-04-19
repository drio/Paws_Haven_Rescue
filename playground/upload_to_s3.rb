require 'sinatra'
require 'aws/s3'

get '/pictures' do
  haml :pictures
end

get '/upload' do
  haml :upload
end

post '/upload' do
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    return haml(:upload)
  end

  #out_filename = "_foo.txt"
  #File.open(out_filename, "w") {|f| f.write(tmpfile.read)}

  AWS::S3::Base.establish_connection!(
    :access_key_id     => "AKIAJCPHOMPVUVQLODCA",
    :secret_access_key => "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")
  AWS::S3::S3Object.store(name, open(tmpfile), "test_drio", :access => :public_read)

  "<img src='https://s3.amazonaws.com/test_drio/#{name}'>"
end

__END__

@@pictures
%h2 pictures

@@upload
%h2 Upload
%form{:action=>"/upload",:method=>"post",:enctype=>"multipart/form-data"}
  %input{:type=>"file",:name=>"file"}
  %input{:type=>"submit",:value=>"Upload"}
