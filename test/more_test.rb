require 'test_helper'

class MoreTest < Test::Unit::TestCase
  def test_compression
    Less::More.compression = true
    assert_equal Less::More.compression?, true
    
    Less::More.compression = false
    assert_equal Less::More.compression?, false
  end
  
  def test_source_path
    Less::More.source_path = "/path/to/flaf"
    assert_equal Less::More.source_path, Pathname.new("/path/to/flaf")
  end
  
  def test_destination_path
    Less::More.destination_path = "/path/to/flaf"
    assert_equal Less::More.destination_path, Pathname.new("/path/to/flaf")
  end
  
  def test_map
    Less::More.source_path = File.join(File.dirname(__FILE__), 'less_files')
    Less::More.destination_path = File.join(File.dirname(__FILE__), 'css_files')
    
    assert_equal Less::More.map, [{ :source => Less::More.source_path.join("test.less"), :destination => Less::More.destination_path.join("test.css") }]
  end
  
  def test_parse
    Less::More.source_path = File.join(File.dirname(__FILE__), 'less_files')
    Less::More.destination_path = File.join(File.dirname(__FILE__), 'css_files')
    Less::More.compression = true
    
    Less::More.parse

    assert_equal Less::More.destination_path.join("test.css").read, ".allforms{font-size:110%;}body{color:#222222;}form{font-size:110%;color:#ffffff;}"
    
    Less::More.destination_path.join("test.css").delete
  end
end
