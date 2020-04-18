# FCM_KEY = ENV['FCM_KEY']

# # https://github.com/spacialdb/fcm
# $fcm = FCM.new(FCM_KEY)

# def send_push_notif(device_push_token, title, body)
# 	registration_ids= [device_push_token] # an array of one or more client registration tokens

# 	# See https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages for all available options.
# 	options = { "notification": {
#   	  "title": title,
# 	    "body": body,
# 	    "sounds": 'default'
#     }
# 	}
	
# 	response = $fcm.send(registration_ids, options)
# end

# def send_test_push_notif(token)
# 	send_push_notif(token, "Test FCM notif (#{Time.now})", "From Sella (#{Time.now})")
# end