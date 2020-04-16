puts "starting app..."

require 'bundler'

require 'active_support'
require 'active_support/core_ext'
require 'sinatra/reloader' #dev-only

puts "requiring gems..."

Bundler.require

puts "loading dotenv..."
Dotenv.load

$app_name   = 'tochen'

require './setup'
require './my_lib'

require_all './db'
require_all './admin'
require_all './bl'
require_all './comm'
require_all './logging'
require_all './mw'

include Helpers #makes helpers globally available 

MEDIUMS = ['email', 'sms']

get '/ping' do
  {msg: "pong from #{$app_name}", val: 'It is always now', foo: '123'}
end

post '/ping' do
  {msg: "post pong from #{$app_name}", val: 'It is always now'}
end

get '/gold' do
	redirect '/me' if cu
	erb :'home/home', default_layout
end

def set_brand(brand)
	session[:brand] = brand
end

def get_brand
	return 'DEFAULT_BRAND'
	# if cu 
	# 	cu[:style]
	# else 
	# 	session[:brand] || DEFAULT_BRAND
	# end
end

get '/entrepreneur' do
	# set_brand(ENTREP_MODE)
	erb :'home/home', default_layout
end

get '/invest' do
	erb :'other/invest', default_layout
end

get '/' do
	erb :'home/home', default_layout
end

get '/sella' do
	redirect '/' if $prod && (pr[:token] != ENV['SELLA_TOKEN'])
	session[:user_id] = sella[:_id]
	redirect '/me'
end

get '/logout' do
	session.clear 
	flash.message = 'תודה, ביי!'
	redirect '/'
end

WELCOME_MSG = "Hi, this is mindy. You will be receiving mindful messages from this number. No need to reply. Have a great day. :)"

def reset_all_login_tokens
	$users.all.each {|u| set_login_token(u) }
end

def set_login_token(user)
	$users.update_id(user['_id'], {token: guid})
end

post '/signup' do
	email    = pr[:email].to_s.downcase
	password = pr[:password].to_s.downcase
	handle   = $users.available_field('handle', email.split(/@/).first)

	if !(email.present? && password.present? && handle.present?)
		flash_err('Missing password or email.') 
		redirect '/signup'
	end

	if email == 'test'
		$users.delete_one({email: 'test'})
	end

	if (user = $users.get(email: email)) || (user = $users.get(handle: handle))
		flash_err('האימייל או שם המשתמש תפוסים.')
		redirect '/signup'
	end

	# -- code for logging in with existing user, by token -- 
	# if user = $users.get(email: email)
	# 	pr_token = pr.hwia[:token].to_s.strip
	# 	pr_token = pr_token.gsub('.','')
	# 	if user[:token].to_s.present? && pr_token.to_s.present? && (user[:token] == pr_token)
	# 		session[:user_id] = user['_id']
	# 		$users.update_id(user['_id'], {token: nil})
	# 		flash.message = 'Welcome back!'
	# 		redirect '/me'
	# 	else 
	# 		flash_err('Email already taken. Enter your token if you received one.')
	# 		redirect '/signup?enable_token=true&email='+email
	# 	end
	
	# else
	data = {email: email, handle: handle}
	# data[:style]    = pr[:style] || DEFAULT_BRAND
	data[:password] = BCrypt::Password.create(password)

	u = user = $users.add(data)
	session[:user_id] = user[:_id] 
	flash.message = 'ברוכים הבאים!'
	redirect '/me'
end

get '/forgot_password' do
	erb :'home/forgot_password', default_layout
end

get '/login' do
	erb :'home/login', default_layout
end

post '/login' do
	email    = pr[:email].to_s.downcase
	password = pr[:password].to_s.downcase
	if (user = $users.get(email: email)) && (BCrypt::Password.new(user[:password]) == password)
		session[:user_id] = user[:_id]
		flash.message = 'ברוכים השבים!'
		redirect '/me'
	else
		flash.message = 'טעות בשם משתמש או סיסמא, נסו שוב.'		
		redirect back
	end
end

FB_REDIRECT_URI = $root_url + '/fb_login'
FB_SECRET = ENV['FB_APP_SECRET']
get '/fb_login' do 
	code = pr[:code]
	url  = "https://graph.facebook.com/v4.0/oauth/access_token?client_id=472876716648358&redirect_uri=#{FB_REDIRECT_URI}&client_secret=#{FB_SECRET}&code=#{code}"
	res  = http_get_json(url)
	bp
	{res: res}
end

get '/signup' do
	erb :'home/signup', default_layout
end

get '/email_login' do
	token = pr[:token]

	if user = $users.get(token: token) 
		session[:user_id] = user[:_id]
		$users.update_id(user[:_id],{token: nil})
		flash.message = "Welcome, #{user[:email]}"
		redirect '/'
	else
		flash.message = 'Token expired, please try again.'
		redirect '/login'
	end
end

get '/about' do
	erb :'other/about', default_layout
end

get '/jobs' do
	erb :'other/jobs', default_layout
end

get '/search' do 
	erb :'search/search', default_layout
end


def render_page(page)
	path = "pages/#{page}"
	erb path.to_sym, layout: :layout
end

def sella
	$users.get(email: 'sella.rafaeli@gmail.com')
end

def set_sella_token
	$users.update_id(sella[:_id],{token: guid})
end
