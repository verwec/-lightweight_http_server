require 'socket'
require_relative 'response'
require_relative 'request'
require 'pry'

class Server
  SERVER_ROOT = '/tmp/'.freeze
  STATUS_OK = 200
  STATUS_NOT_FOUND = 404
  HOST = 'localhost'.freeze
  PORT = '8080'.freeze

  def run
    loop do
      socket = server.accept
      request = Request.new(socket.readpartial(2048))
      response = response_for(request)
      socket.write(response)
      socket.close
    end
  end

  private

  def response_for(request)
    if File.exist?(SERVER_ROOT + request.path)
      data = File.binread(SERVER_ROOT + request.path)
      Response.new(code: STATUS_OK, data: data)
    else
      Response.new(code: STATUS_NOT_FOUND)
    end
  end

  def server
    @server ||= TCPServer.new(HOST, PORT)
  end
end
