require 'test/unit'

begin
  require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'environment')
rescue LoadError => e
  puts "Please run these tests within a Rails app"
  exit
end

begin
  require 'less'
rescue LoadError => e
  e.message << " (You may need to install the less gem)"
  raise e
end

require 'more'