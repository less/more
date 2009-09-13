begin
  require 'less'
rescue LoadError => e
  e.message << " (You may need to install the less gem)"
  raise e
end

require File.join(File.dirname(__FILE__), 'lib', 'more')

if Rails.env == "production"
  config.after_initialize { Less::More.parse }
else
  ActionController::Base.before_filter { Less::More.parse }
end