$posts = $mongo.collection('posts');

post '/create' do 
	require_user
	res = $posts.add({user_id: cuid})	
	redirect "/posts/#{res[:_id]}"
end

get '/posts/:id' do 
	erb :'/posts/post', default_layout
end
