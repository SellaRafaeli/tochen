MANAGEABLE_COLLECTIONS = ['users', 'sent_messages', 'feedback', 'errors', 'skipped_messages']
MANAGEABLE_COLLECTIONS.map! {|n| $mongo.collection(n) }

get '/admin/user_page' do
  user = $users.get(_id: pr[:_id])
  erb :'admin/user_page', locals: {user: user}, layout: :layout
end

get '/admin/login_as' do
  user = $users.get(email: pr[:email])
  session[:user_id] = user[:_id]
  flash.message = "You are now logged in as #{user[:email]}"
  redirect '/'
end

post '/admin/send_msg_now' do
  user = $users.get(email: pr[:email])
  text = pr[:text]
  send_user_msg(user, {force_good_time: true, text: text})
  redirect back
end

get '/admin/dashboard' do
  full_page_card(:"admin/admin_dashboard")  
end

get '/is_admin' do
  #session[:is_admin] = true if params[:foo] = 'bar'
  {is_admin: is_admin}
end

def is_admin(user = cu)
  admin_authorized?
rescue 
  false
end

get '/admin' do
  redirect '/admin/manage/users'
  #  to_page(:"admin/dashboard")
  #session[:is_admin] = true
  #redirect '/admin/manage/users'
end

get "/admin/manage/:coll" do 
  erb :"admin/items", default_layout
end 

before '/admin*' do
  protected!
end

def verify_admin_val(collection, field, val)
  # if you want to verify admin value, you can do it by collection
  # and/or field 
  # mock-code
  # if collection == 'something'
  #   if field == 'something'
  #     halt_bad_input(msg: 'Bad input')

  val
end

post '/admin/create_item' do
  require_fields(['coll'])
  coll = $mongo.collection(params[:coll])
  fields = mongo_coll_keys(coll)
  data   = params.just(fields)
  coll.add(data)
  redirect back
end

post '/admin/update_item' do
  require_fields(['id','field','coll'])
  coll, field, val = params[:coll], params[:field], params[:val]
  verified_val = verify_admin_val(coll, field, val)
  res = $mongo.collection(params[:coll]).update_id(params[:id],{field => verified_val})
  {msg: "ok", new_item: res}
end

post '/admin/delete_item' do
  require_fields(['id','coll'])
  $mongo.collection(params[:coll]).delete_one({_id: params[:id]})
  {msg: "ok"}
end


