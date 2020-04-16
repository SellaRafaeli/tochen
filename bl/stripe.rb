$stripe_notifs = $mongo.collection('stripe_notifs')

SUCCESS_STRIPE_NOTIFS_TYPES = ["checkout.session.completed", "customer.subscription.created"]

post '/stripe_notif' do
	$stripe_notifs.add(pr)

	begin
		type    = pr[:type]
		user_id = pr[:data]['object']['client_reference_id']
		if user_id && type.in?(SUCCESS_STRIPE_NOTIFS_TYPES)
			$users.update_id(user_id, {paid: true, paid_at: Time.now}) rescue nil
		end
	rescue => e
		log_e(e)
	end
	
	{msg: 'ok'}	
end

# get '/pricing' do
# 	erb :'pricing/pricing', default_layout
# end

# get '/donate' do
# 	redirect '/pricing'	
# end

get '/donation_success' do
	flash.message="Great, thanks!"
	redirect '/'
end

get '/donation_failure' do
	flash.message="Something went wrong with your donation"
	redirect '/'
end