def flash_err(msg)
	session[:flash_type] = :danger
	flash.message = msg
end

def flash_back(msg, type = 'info') 
	#possible types: primary, secondary, success, danger, warning, success, info, light, dark
	session[:flash_type] = type
	flash.message = msg
	redirect back
end

after do 
  session[:device_id] ||= guid
  request_time = Time.now - @time_started_request rescue nil
  log_request({time_took: request_time}) unless request_is_public?
  if @response.body.is_a? Hash #return hashes as json
    #@response.body = {data: @response.body}
    @response.body[:time] = request_time
    content_type 'application/json'
    @response.body = @response.body.to_json   
  end 
end

get '/mw/outgoing' do 'refresh' end