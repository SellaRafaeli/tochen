$views = $mongo.collection('views')

def record_view(post_id, user_id)
  data = {post_id: post_id, user_id: user_id, device_id: session[:device_id]}
  data[:referrer] = _req.referrer.to_s rescue ''
  $views.add(data)
end