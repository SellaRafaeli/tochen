$errors = $mongo.collection('errors')

module Helpers
  def log_e(err, data = {})  
    err = {msg: err.to_s, backtrace: err.backtrace.to_a.slice(0,4)} if err.is_a? Exception
    err = {msg: err} unless err.is_a? Hash
    err[:user_id]  = cuid rescue 'nil'
    err[:email]    = cu[:email] rescue 'no-email'
    err[:path]     = request_path rescue 'no-path'
    err[:params]   = JSON.parse(_params.to_json) rescue {} #sometimes params has un-BSON able fields
    $errors.add(err)
  rescue => e
    puts e
  end
end

error do 
  e = env['sinatra.error']    
  log_e(e)
  data = {msg: "an error occurred", e: e.to_s, backtrace: e.backtrace.to_a.slice(0,4).to_s}
  if $prod  
    flash.message = 'Oops! Something went wrong.'
    redirect '/'
  end
  data
  # if request_expects_json?
  #   data 
  # else 
  #   full_page_card(:"other/500", locals: {data: data})
  # end
end

not_found do
  flash.message = "Oops, looks like that page is still missing." unless request_is_public?
  log_e("missed page #{_req.path} with pr #{pr.to_json}")
  redirect '/'
  return {err: 'No such route'}

  # if request_expects_json?
  #   content_type 'application/json'
  #   status 404
  #   redirect '/'
  # else 
  #   full_page_card(:"other/404")     
  # end
end

get '/error' do
  log_e('first')
  a = b 
end


