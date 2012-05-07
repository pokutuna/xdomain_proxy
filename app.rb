require 'sinatra'
require 'open-uri'
require 'uri'

before do
  response['Access-Control-Allow-Origin'] = '*'
end

get '/*' do
  uri = URI.parse(request.env["REQUEST_URI"][1..-1])
  return 400 unless URI::HTTP === uri

  begin
    response = open(uri)
    return response.read
  rescue => e
    return 400
  end
end
