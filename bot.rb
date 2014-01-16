require 'bundler/setup' 

require 'mumble-ruby'
require 'dicebag'

puts DiceBag::Roll.new(" 1d6".strip()).result

cli = Mumble::Client.new('aypsela.com', 64738, 'botbot', '')
# => #<Mumble::Client:0x00000003064fe8 @host="localhost", @port=64738, @username="Mumble Bot", @password="password123", @channels={}, @users={}, @callbacks={}>

$last = "1d6"

def roll(cli, x)
  begin
    result = DiceBag::Roll.new(x.strip).result
    $last = x.strip
  rescue Exception => e
    puts e
    cli.text_channel(cli.current_channel, "There was an error parsing your dice string")
  end
  if result
    puts "r: " + result.to_s
    cli.text_channel(cli.current_channel, result.to_s)
  end
  puts "sent"
end

# Set up some callbacks for when you recieve text messages
# There are callbacks for every Mumble Protocol Message that a client can recieve
# For a reference on those, see the linked PDF at the bottom of the README.
cli.on_text_message do |msg|
  puts msg.inspect
  #cli.text_channel(cli.current_channel, msg.message)
  msg.message.match(/(?:dice|d):(.+)/) do |x|
    puts x[1]
    roll(cli, x[1])
  end

  if msg.message == "reroll" || msg.message == "r"
    roll(cli, $last)
  end
end
# => [#<Proc:0x0000000346e5f8@(irb):2>]

# Initiate the connection to the client
cli.connect

a = gets.chomp

while a != quit

  a = gets.chomp
end

c.disconnect
