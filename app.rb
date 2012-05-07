require 'sinatra'
require 'open-uri'
require 'uri'

before do
  response['Access-Control-Allow-Origin'] = '*'
end

get '/' do
  return <<-"EOS"
<h1>xdomain proxy</h1>
<p>access http://#{request.env["HTTP_HOST"]}/&lt;url&gt;</p>
  EOS
end

get '/*' do
  begin
    uri = URI.parse(request.env["REQUEST_URI"][1..-1])
    raise ArgumentError unless URI::HTTP === uri

    response = open(uri)
    return response.read
  rescue => e
    return 400
  end
end
