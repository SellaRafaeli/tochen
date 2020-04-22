$prod       = settings.production? #RACK_ENV==production?
$prod_url   = 'https://www.תוכן.com'
$root_url   = $prod ? $prod_url : 'http://localhost:2021'

ONE_YEAR_IN_SECONDS = 31556952
SESSION_SECRET = ENV['SESSION_SECRET'] || '&a!*^n31994@'
use Rack::Session::Cookie, :key => "rack.session",  :expire_after => ONE_YEAR_IN_SECONDS, :secret => SESSION_SECRET

# enable :sessions
# set :session_secret, ENV['SESSION_SECRET'] || '&a!*^n31994@'
set :raise_errors,          false
set :show_exceptions,       false
set :erb, :layout =>    false

configure do
  enable :cross_origin
end

def bp
  binding.pry
end

def get_fullpath
  $root_url + request.fullpath
end

configure :development do |c|
  require 'sinatra/reloader' 
  enable :reloader
  c.also_reload "./**/*.rb" 
end
# configure :development, :production do
#  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///testdb')

#  ActiveRecord::Base.establish_connection(
#    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#    :host     => db.host,
#    :username => db.user,
#    :password => db.password,
#    :database => db.path[1..-1],
#    :encoding => 'utf8'
#  )
# end

# class Post < ActiveRecord::Base
# end

# class Author < ActiveRecord::Base
# end