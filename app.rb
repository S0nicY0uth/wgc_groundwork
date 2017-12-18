require 'sinatra'
require './lib/profile'

set :application_id, '4524629a2353c090e319b11d57c191fd94dc605b98da38704bd78d7fc152419d'
set :secret, '96aeeb4f534b02518b3f9c2124db80ac4cd65e244fd00276ef8c1074431caf75'
set :redirect_uri, 'http://localhost:4567/callback'
set :site_url, 'https://wegotcoders.com'
set :session_secret, 'secret'
enable :sessions

get '/primes' do
  # TODO - Can we make this dynamic?
  limit = 200

  # TODO - add your prime number solution in the primes.rb file.
  @sum = Primes.sum_to(limit)

  erb :primes, :layout => :main
end

get '/' do
  if signed_in?
    @profile = trainee.get_profile
    @personal = [
      {
        id: @profile['id'],first_name: @profile['first_name'],last_name: @profile['last_name'],gender: @profile['gender'],tel: @profile['phone_number'], dob: @profile['dob'],github: @profile['github'],twitter: @profile['twitter'],nickname: @profile['nickname'],nickname: @profile['nickname'],employed: @profile['employment_status'],site: @profile['homepage']
      }
    ]
  end

  erb :index, :layout => :main
end

post '/update' do
  response = trainee.update_profile(params)

  if @errors = response["errors"]
    erb :error, :layout => :main
  else
    redirect '/'
  end
end

include Sinatra::OauthRoutes

def trainee
  @trainee ||= WeGotCoders::Trainee.new(settings.site_url, session[:access_token])
end
