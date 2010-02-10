require 'test/unit'

require 'rubygems'
require 'mocha'
require 'active_support'
require 'action_controller'

ActionController::Base.session_store = nil

module Rails
  extend self
  
  def env
    "development"
  end
  
  def root
    Pathname.new("/tmp")
  end
  
  def backtrace_cleaner
    ActiveSupport::BacktraceCleaner.new
  end
end

class ApplicationController < ActionController::Base
end

begin
  require 'less'
rescue LoadError => e
  e.message << " (You may need to install the less gem)"
  raise e
end

RAILS_ROOT = Rails.root

require 'more'