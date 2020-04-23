class Hash
  def just(firstItem, *args)
    args = (firstItem.is_a? Array) ? firstItem : args.unshift(firstItem)

    args = (args.map {|v| v.to_s}) + (args.map {|v| v.to_sym})
    self.slice(*args).compact.hwia
  end

  def hwia
    HashWithIndifferentAccess.new self
  end

  def compact
    delete_if { |k, v| !v.present? }
  end
end

class Array
  def just(opts_arr)
    res = select {|v| v.in?(Array(opts_arr))}
  end

  def avg
    (self.reduce(:+) / self.size.to_f).round(2)
  end

  def mapo(field)
    self.map {|el| el[field]}
  end

  def mapf(method_name)
    self.map(&method(method_name.to_sym))
  end

  def hash_of_num_occurrences
    self.each_with_object(Hash.new(0)){|word,counts|counts[word]+=1}.sort_by{|k,v|v}.reverse.to_h
  end

  def to_simple_hash
    self.reduce({}) {|h,k| h[k.to_s] = k; h }.hwia
  end
end

def time(&block) #to call: time { get '/u/ann-oates' }
  before = Time.now; yield; puts "Took: #{Time.now-before}"
end

def to_numeric(n)
  return n.to_s.to_i if n.to_s == n.to_s.to_i.to_s  
  return n.to_s.to_f if n.to_s == n.to_s.to_f.to_s  
  n
end

def guid
  SecureRandom.uuid
end

def either(val1,val2 = nil)
  val1.present? ? val1 : val2
end

def small_id(size = 4)
  #(0..size - 1).to_a.map { [*('a'..'z'),*('0'..'9')].sample }.join
  nums  = ('0'..'9').to_a
  chars = ('a'..'z').to_a
  [nums.sample, nums.sample, nums.sample, chars.sample, chars.sample].join
end

def nice_id
  #return rand(Time.now.to_i*100).to_s(36)
  res = SecureRandom.urlsafe_base64(7,false)[0..4]
  res = nice_id if $posts.get(res)      
  res
end

## Time 

def nice_date(time, opts = {})
  #time.strftime("%B %e") #"Jul 9, 12:55 PM"
  #time.strftime("%A, %b #{time.day.ordinalize}")
  time.strftime("%e/%-m/%Y")
end

def nice_datetime(time, opts = {})
  time.strftime("%b %e, %l:%M %p") #"Jul 9, 12:55 PM"
end

def nice_time(time, opts = {}) #http://www.foragoodstrftime.com/  
  time.strftime("%l:%M %p") #"12:55 PM"
end

def rand_time(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end

# String
class String
  def first_letter_upcase!
    self[0] = self[0].upcase
    self
  end

  def first_letter_downcase!
    self[0] = self[0].downcase
    self
  end

  def just_digits
    tr('^0-9', '') 
  end

  def ensure_prefix(prefix)
    starts_with?(prefix) ? self : prefix.to_s+self 
  end

  def without(substr)
    gsub(substr,'')
  end
end

def is_a_valid_email?(email)
  (email =~ /^(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}$/i)
end

def valid_email(email)
  URI::MailTo::EMAIL_REGEXP.match?(email)
end

def rand_str
  Faker::Hacker.ingverb
end

def rand_url
  Faker::Internet.url
end

def load_json(path)
  JSON.load(File.read(path)).hwia
end

def reload
  exec $0, *ARGV #makes tux reload when running "reload"
end

def prob(probability)
  rand < probability
end