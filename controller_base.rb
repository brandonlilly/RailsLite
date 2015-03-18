require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'

require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params, :session

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def render(template_name)
    file_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    template =  File.read(file_path)
    html =      ERB.new(template).result(binding)
    render_content(html, 'text/html')
  end

  def redirect_to(url)
    raise if already_built_response?
    res.status = 302
    res['location'] = url
    @already_built_response = true
    session.store_session(res)
  end

  def render_content(content, content_type)
    raise if already_built_response?
    self.res.content_type = content_type
    self.res.body = content
    @already_built_response = true
    session.store_session(res)
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    content = send(name)
    # unless already_built_response?
    #   render_content(content, content_type)
    # end
  end
end
