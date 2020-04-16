

require './app'

use Rack::Protection::EscapedParams  #https://github.com/sinatra/sinatra/tree/master/rack-protection
run Sinatra::Application

puts "#{$app_name} is now running."