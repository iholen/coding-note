require "socket"

class Server
  def initialize(port, ip)
    @server = TCPServer.open(ip, port)
    @connections = Hash.new
    @connections[:clients] = Hash.new
    run
  end

  def run
    loop {
      Thread.start(@server.accept) do |client|
        user_name = client.gets.chomp.to_sym

        # 判断是否存在该用户
        exist_client = @connections[:clients].has_key?(user_name)

        if exist_client
          client.puts "This username already exist"
          Thread.kill self
        else  
          send_message(user_name, "#{user_name} has joined chatting")
        end

        puts "#{user_name} #{client}"
        @connections[:clients][user_name] = client
        client.puts "Thank you for joining! Happy chatting"
        listen_user_messages(user_name, client)
      end
    }.join
  end

  def listen_user_messages(user_name, client)
    loop {
      msg = client.gets.chomp
      send_message(user_name, "#{user_name}: #{msg}")
    }
  end

  def send_message(user_name, message)
    @connections[:clients].each do |other_name, other_client|
      unless other_name == user_name
        other_client.puts message
      end
    end
  end  
end

Server.new(3000, "localhost")