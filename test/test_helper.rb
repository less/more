# fake Rails with loaded plugin
require 'rubygems'
require 'active_support'
require 'action_pack'
require 'action_controller'

module Rails
  def self.root
    File.expand_path(File.dirname(__FILE__))
  end

  def self.backtrace_cleaner
    ActiveSupport::BacktraceCleaner.new
  end
  
  def self.env
    'development'
  end
end

#RAILS_ENV = 'development'

# load plugin
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'less/more'
load 'init.rb'

# load testing libs
require 'test/unit'
require 'active_support/test_case'
begin; require 'redgreen'; rescue LoadError; end
require 'shoulda'

# setup controller testing
require 'action_controller/test_process'
ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

# test helpers
def css_path
  "#{Rails.root}/public/css"
end

def less_path
  "#{Rails.root}/less_files"
end

def write_less file, content
  write_content File.join(less_path, file), content
end

def write_css file, content
  write_content File.join(css_path, file), content
end

def write_content file, content
  `mkdir -p #{File.dirname(file)}`
  File.open(file,'w'){|f| f.print content }
end

def read_css(file)
  raise ArgumentError.new("#{file.inspect} missing") unless File.exist?(File.join(css_path, file))
  File.read(File.join(css_path, file)) rescue nil
end

def assert_include(item, obj)
  obj_without_whitespace = obj.gsub(/\s/,'')
  item_without_whitespace = item.gsub(/\s/,'')
  assert_block("#{obj.inspect}\ndoes not include\n#{item.inspect}."){ obj_without_whitespace.include? item_without_whitespace }
end

def assert_not_include(item, obj)
  obj_without_whitespace = obj.gsub(/\s/,'')
  item_without_whitespace = item.gsub(/\s/,'')
  assert_block("#{obj.inspect}\ndoes include\n#{item.inspect}."){ !obj_without_whitespace.include? item_without_whitespace }
end

def setup_for_generate_test
  Less::More.source_path = less_path
  Less::More.destination_path = css_path
  Less::More.header = false
  `mkdir -p #{css_path}`
end

def teardown_for_generate_test
  `rm -rf #{css_path}`
  `rm -rf #{less_path}`
end
