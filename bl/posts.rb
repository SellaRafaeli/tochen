$posts = $mongo.collection('posts');

def get_posts(opts = {})
	$posts.all(opts, sort: [{created_at: -1}])
end

def get_post_mins(post)
	total_words = 0; 
  post[:ps].to_a.each {|p| total_words+=p[:text].to_s.size if p[:type] == 'text' }
  num_mins    = (total_words / 300.0).round
  num_mins    = 2 if num_mins < 2
  num_mins 
end

def get_post_og_img(post)
	para = (post[:ps].to_a.find {|p| p['type'] == 'img' } || {})
	para['src'] || 'https://תוכן.com/favicon.ico'
end

def get_post_og_desc(post)	
	para = post[:ps].to_a.find {|p| p['type'] == 'text'} || {}
	text = "#{para['text'][0..4000]}"
	text
end

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
	post_id    = pr[:post_id]
	post       = $posts.get(post_id) || {}
	is_owner   = post[:user_id]==cuid
	
	err = nil
	err = 'No such post' if !post 
	err = 'No such post' if post && post[:post_open]!='yes' && !is_owner
	if err
		flash_err(err) 
		redirect '/'
	end

	record_view(pr[:post_id], cuid) unless is_owner
	erb :'/posts/post', default_layout
end

get '/@*' do 
	erb :'users/user', default_layout	
end
