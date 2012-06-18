# -*- coding: utf-8 -*-
require 'sinatra'
require 'haml'
require 'open-uri'
require 'uri'

before do
  response['Access-Control-Allow-Origin'] = '*'
end

get '/index' do
  haml :index
end

get '/*' do
  uri_str = request.env["REQUEST_URI"][1..-1]
  redirect '/index' if uri_str.length.zero?

  begin
    uri = URI.parse(uri_str)
    return 400 unless URI::HTTP === uri
    return open(uri).read rescue return 404
  rescue => e
    return 500
  end
end

__END__

@@layout
!!!
%html
  %head
    %title xdomain proxy
  %body{:style => 'padding: 30px;'}
    = yield

@@index
%section
  %header
    %h1 xdomain proxy
    クロスドメインアクセスのためのhttp proxyです。
  %h3 つかいかた: http://#{request.env["HTTP_HOST"]}/&lt;アクセスしたいURL&gt;
  %footer
    %a{:href => 'https://github.com/pokutuna/xdomain_proxy'} Github pokutuna/xdomain_proxy
