require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    # render_content("This is my testtttt", "text/html")
#     redirect_to("http://google.com")
render(:show)
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
