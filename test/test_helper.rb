require 'test/unit'

require 'rubygems'
require 'active_support'

class Rails
  def self.root
    File.expand_path(File.dirname(__FILE__))
  end
end

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'less/more'