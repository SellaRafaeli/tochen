$posts = $mongo.collection('posts');

post '/create' do 
	require_user
	res = $posts.add({user_id: cuid})	
	redirect "/@#{cu['handle']}/#{res[:_id]}"
end

post '/posts/:id' do 
	data = pr
	id   = pr[:id]
	old  = $posts.get(id)
	
	halt(404, {err: 'not found'}) if !old 
	halt(401, {err: 'no permissions'}) if !(old[:user_id] == cuid) 
		
	res = $posts.update_id(id, data)
	{post: res}
end

get '/@*/:post_id' do
	post = $posts.get(pr[:post_id])

	err = nil
	err = 'No such post' if !post 
	err = 'No such post' if post && post[:post_open]!='yes' && post[:user_id]!=cuid
	if err
		flash_err(err) 
		redirect '/'
	end
	erb :'/posts/post', default_layout
end

get '/@*' do 
	erb :'users/user', default_layout	
end
