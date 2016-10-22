require 'sinatra'
require 'haml'
require 'logger'

set :environment, :production
set :root, File.dirname(__FILE__)

before do
  logger.level = Logger::WARN
end

def file_listing(directory)
  Dir.glob(directory + '/*')
end

get '/files/*' do
  filename = params['splat'].first

  file = File.join(settings.root, filename)
  send_file file
end

get '/*' do # |file_path|
  file_path = params['splat'].first
  puts "====== #{file_path} ======"
  @file_path = file_path
  @files = file_listing(settings.root + "/" + file_path)
  haml :index
end

__END__

@@ layout
%html
  %a{:href => '/'}top
  = yield

@@ index
%h1 File Server
%table
  %tr
    %th File
    %th Size
  - for file in @files
    %tr
      %td
        - if File.file?(file)
          - if @file_path == ''
            %a{:title => file, :href => '/files/' + File.basename(file)}=File.basename(file)
          - else
            %a{:title => file, :href => '/files/' + @file_path + '/' + File.basename(file)}=File.basename(file)
        - else
          - if @file_path == ''
            %a{:title => file, :href => '/' + File.basename(file)}=File.basename(file)
          - else
            %a{:title => file, :href => '/' + @file_path + '/' + File.basename(file)}=File.basename(file)
      %td= File.size(file).to_s + "b"
