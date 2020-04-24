$views = $mongo.collection('views')

def record_view(post_id, user_id)
	$views.add({post_id: post_id, user_id: user_id, device_id: session[:device_id]})
end