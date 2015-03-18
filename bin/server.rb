require 'webrick'

require_relative '../lib/loader.rb'

$router = Router.new
require_relative '../app/routes.rb'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = $router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
