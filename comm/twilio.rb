def twilio_send(msg, to_num)
  account_sid = ENV['TWILIO_ACCOUNT']
  auth_token = ENV['TWILIO_TOKEN']
  client = Twilio::REST::Client.new(account_sid, auth_token)

  from = '+14153267892' # Your Twilio number
  to = to_num.to_s.ensure_prefix('+')

  puts "sending twilio message #{from} to #{to}, body #{msg}"
  if $prod
    res = client.messages.create(from: from, to: to, body: msg)
    # $sent_messages.add(...)
    res
  else 
    return "<skipping actual SMS since not prod>"
  end
end

def twilio_send_whatsapp(msg, to_num)
  account_sid = ENV['TWILIO_ACCOUNT']
  auth_token = ENV['TWILIO_TOKEN']
  client = Twilio::REST::Client.new(account_sid, auth_token)

  message = client.messages.create(
                             from: 'whatsapp:+14153267892',
                             body: 'Hello there!',
                             to: 'whatsapp:+972522934321'
                           )

  puts message.sid
end