require 'test_helper'

class MoreTest < Test::Unit::TestCase
  def setup
    class << Less::More
      [:@compression, :@header, :@page_cache].each {|v| remove_instance_variable(v) if instance_variable_defined?(v) }
    end
  end
  
  def teardown
    FileUtils.rm_rf(Less::More.destination_path)
  end
  
  def test_getting_config_from_current_environment_or_defaults_to_production
    Less::More::DEFAULTS["development"]["foo"] = 5
    Less::More::DEFAULTS["production"]["foo"] = 10
    
    Rails.expects(:env).returns("development")
    assert_equal 5, Less::More.get_cvar("foo")
    
    Rails.expects(:env).returns("production")
    assert_equal 10, Less::More.get_cvar("foo")
    
    Rails.expects(:env).returns("staging")
    assert_equal 10, Less::More.get_cvar("foo")
  end
  
  def test_cvar_gets_predesence_for_user_values
    Less::More::DEFAULTS["development"][:page_cache] = false
    assert_equal false, Less::More.page_cache?
    
    Less::More.page_cache = true
    assert_equal true, Less::More.page_cache?
  end
  
  def test_page_cache_off_on_heroku
    Less::More.page_cache = true
    Less::More::DEFAULTS["development"][:page_cache] = true
    
    # The party pooper
    Less::More.expects(:heroku?).returns(true)
    
    assert_equal false, Less::More.page_cache?
  end
  
  def test_compression
    Less::More.compression = true
    assert_equal Less::More.compression?, true
    
    Less::More.compression = false
    assert_equal Less::More.compression?, false
  end
  
  def test_source_path
    Less::More.source_path = "/path/to/flaf"
    assert_equal Pathname.new("/path/to/flaf"), Less::More.source_path
  end
  
  def test_destination_path
    Less::More.destination_path = "/path/to/flaf"
    assert_equal Pathname.new("/path/to/flaf"), Less::More.destination_path
  end
  
  def test_map
    Less::More.source_path = File.join(File.dirname(__FILE__), 'less_files')
    Less::More.destination_path = File.join(File.dirname(__FILE__), 'css_files')
    
    assert_equal [
      {:source => Less::More.source_path.join("test.less"), :destination => Less::More.destination_path.join("test.css") },
      {:source => Less::More.source_path.join("short.lss"), :destination => Less::More.destination_path.join("short.css")}
    ], Less::More.map
  end
  
  def test_parse
    Less::More.source_path = File.join(File.dirname(__FILE__), 'less_files')
    Less::More.destination_path = File.join(File.dirname(__FILE__), 'css_files')
    Less::More.compression = true
    
    Less::More.parse

    assert_equal ".allforms{font-size:110%;}body{color:#222222;}form{font-size:110%;color:#ffffff;}", Less::More.destination_path.join("test.css").read
  end
  
  def test_lss
    Less::More.source_path = File.join(File.dirname(__FILE__), 'less_files')
    Less::More.destination_path = File.join(File.dirname(__FILE__), 'css_files')
    
    Less::More.parse
    assert File.file?(Less::More.destination_path.join("short.css"))
    assert_equal "p { color: red; }\n", File.read(Less::More.destination_path.join("short.css"))
  end
end
