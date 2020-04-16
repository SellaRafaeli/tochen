$postmark_client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])

def send_email(to, subj, html_body)
  $postmark_client.deliver(
    from: 'ceo@usemindy.com',
    to: to,
    subject: subj,
    html_body: html_body,
    track_opens: true
  )
rescue => e
  log_e(e)
  false
end

def send_login_sms(user)
	token = guid
	$users.update_id(user[:_id], {token: token})
	msg = "Hi, click here to log in: #{$root_url}/email_login?token=#{token}"
	twilio_send(msg, user[:num])
end

def send_login_email(user)
  token = guid
  $users.update_id(user[:_id], {token: token})
  msg = "Hi, click here to log in: #{$root_url}/email_login?token=#{token}"
  send_email(user[:email], "Mindy login link - #{Time.now}",msg)
end

def send_mindy_msg_email(msg, email)
  subj = msg
  html = msg+'<br/><br/>this message is from mindy, your mental well-being helper. See <a href="https://usemindy.com">https://usemindy.com.</a>'
  send_email(email, subj, html)
end

def send_please_enter_app(user)
  if user[:email] && !user[:device_push_token] && user[:token]
    subj = 'Mindy - moving to an app'
    html = "Hey! Thanks for using mindy. We hope you've been enjoying it! <br/><br/> Mindy  now has awesome mobile apps, through which new features will be released, such as giving feedback on what type of messages you like most and 2-way interaction with Mindy.<br/><br/>To keep using Mindy and download the app, click on the link for your store:<br/><br/><a href='https://apps.apple.com/us/app/mindy-mindful-ai-assistant/id1484046182'>https://apps.apple.com/us/app/mindy-mindful-ai-assistant/id1484046182</a><br/><br/><a href='https://play.google.com/store/apps/details?id=com.mindy.app&hl=en'>https://play.google.com/store/apps/details?id=com.mindy.app&hl=en</a><br/><br/><b>In order to log in to the app, you will need to use your email (#{user[:email]}), and this token as a one-time password: #{user[:token]}.</b><br/><br/>

We are moving to sending Mindy's messages through app push notifications instead of via SMS text messages. This is in order for us to be able to help as many people as possible without charging money. <br/><br/> Thus, we will stop sending SMS text message on January 1st, 2020. We hope you enjoy using the mobile app!<br/><br/>If you have ANY problems or suggestions for features, please contact me directly at ceo@usemindy.com.<br/><br/>I genuinely hope you have a good day.<br/><br/> -Sella, CEO of usemindy.com"
    send_email(user[:email], subj, html)
    return nil
  else 
    return user[:email]
  end
end

# def send_default_email #for testing
#   subj = "test subject #{Time.now}"
#   send_email('sella.rafaeli@gmail.com', subj, '<strong>Hello</strong> dear Postmark user.')
# end

