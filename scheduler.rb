require './app'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

def send_to_all_users
	$users.all(active: true).each {|user| 
		if user['device_push_token'] || (user[:num].to_s.length > 6)
			send_user_msg(user)
		end
	}
end

scheduler.every '175m' do
	send_to_all_users	
end

# scheduler.every '210m' do
#   liliya  = all_users[1]  
#   send_user_msg(liliya)
# end


puts "Mindy Scheduler is now running."
scheduler.join
# EVERY_DAY_AT_5_AM                = '0 5 * * *' #time is GMT
# EVERY_DAY_AT_5_MIN_PAST_EIGHT_PM = '5 20 * * *'
# EVERY_DAY_AT_30_MIN_PAST_TEN_PM  = '30 22 * * *'
# EVERY_DAY_AT_1900                = '0 19 * * *'
# EVERY_MONDAY_AT_NOON             = '00 10 * * mon'

# (see "man 5 crontab" in your terminal)