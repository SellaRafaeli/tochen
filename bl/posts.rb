$posts = $mongo.collection('posts');

post '/create' do 
	res = $posts.add({})	
	redirect "/posts/#{res[:_id]}"
end

get '/posts/:id' do 
	erb :'/posts/post', default_layout
end
