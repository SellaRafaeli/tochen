# migrate posts with 'body' string to 'ps' hash

def migrate_posts_to_ps
	$posts.all.each do |post| 
		body = post['body']
		ps   = [{type: 'text', text: body}]
		$posts.update_id(post[:_id], ps: ps)
		puts "migrated body: #{body}"
	end
	puts "done"
end