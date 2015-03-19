# encoding: UTF-8
require_relative '../lib/loader.rb'

$router = Router.new
require_relative '../app/routes.rb'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  req.body.try(:force_encoding, 'utf-8')
  req.path.try(:force_encoding, 'utf-8')
  req.query_string.try(:force_encoding, 'utf-8')

  route = $router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
