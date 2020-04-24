$users = $mongo.collection('users')

DEFAULT_PIC = '/img/profile.png'

get '/me' do
	redirect_unless_user

	erb :'me/me', default_layout
end

post '/update_me' do
	redirect_unless_user

	data = pr
	data[:handle].gsub!(/[^0-9A-Za-z]/, '')

	if (user = $users.get(handle: data[:handle])) && (user[:_id]!=cuid)
		flash_err 'שם משתמש תפוס.'
		redirect '/me'
	end

	user = $users.update_id(cu['_id'],data)
	flash.message = 'עדכנתי!'

	redirect '/me'
end

# get '/onboarding' do
#   erb :'onboarding/onboarding', default_layout
# end

# get '/settings' do
# 	erb :'me/settings', default_layout
# end

# if !$prod 
# 	get '/dev_login' do
# 		user = sella #$users.random
# 		session[:user_id] = user[:_id]
# 		redirect '/me'
# 	end
# end

# post '/my_device_push_token' do
# 	halt(401, {err: 'no user detected'}) unless cu
# 	res = $users.update_id(cu['_id'],{device_push_token: pr[:deviceToken]})
# 	{msg: "ok, set deviceToken to #{pr[:deviceToken]}"}
# end	

# post '/onboarding' do
# 	redirect_unless_user
# 	data = pr 
# 	user = $users.update_id(cuid, data)
# 	res  = {has_push: !!user[:device_push_token]}
# 	res
# end

# post '/update_settings' do
# 	redirect_unless_user

# 	custom_msgs     = pr[:custom_msgs].to_s[0..20000]
# 	custom_msgs_pct = pr[:custom_msgs_pct].to_i
# 	data = {custom_msgs: custom_msgs, custom_msgs_pct: custom_msgs_pct}

# 	data[:style]          = pr[:style]
# 	data[:email_features] = !!pr[:email_features]
# 	data[:email_all] = !!pr[:email_all]
# 	data[:desired_state] = pr[:desired_state]
# 	$users.update_id(cu[:_id], data)
# 	flash.message = 'Updated your settings.'
# 	redirect '/settings'
# end