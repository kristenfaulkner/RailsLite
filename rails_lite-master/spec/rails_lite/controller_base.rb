require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_reeponse = false
    @my_params = Params.new(req, route_params)

  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "Invalid" if @already_built_response
    @res["Content-Type"] = type 
    @res.body = content
    session.store_session(@res) 
    @already_built_response = true    
  end

  # helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
      raise "Invalid" if @already_built_response
      @res.header["location"] = url
      @res.status = 302
      @already_built_response = true
      session.store_session(@res)
      @already_built_response = true    
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    name = "views/" + self.class.to_s.underscore + "/" + template_name.to_s + ".html.erb"
    file = File.read(name)
    content = ERB.new(file).result(binding)
    render_content(content, "text/html" )
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@res)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    self.render(name) unless already_built_response?
  end
end
