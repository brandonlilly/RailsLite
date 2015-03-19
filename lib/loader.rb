require 'uri'
require 'json'
require 'webrick'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'
require 'yaml'

require_relative 'controller_base'
require_relative 'router'
require_relative 'params'
require_relative 'session'
require_relative 'flash'

require_relative 'active-record-lite/model_base.rb'

Dir["app/controllers/*.rb"].each {|file| require_relative "../#{file}" }
Dir["app/models/*.rb"].each      {|file| require_relative "../#{file}" }
