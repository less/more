require 'test_helper'

class MoreTest < Test::Unit::TestCase
  def setup
    [:compression, :header, :destination_path, :source_path].each do |variable|
      Less::More.send("#{variable}=", nil)
    end
  end

  def prepare_for_generate
    Less::More.source_path = 'less_files'
    Less::More.destination_path = 'css'

    css = "#{Rails.root}/public/css"
    `rm -rf #{css}`
    `mkdir -p #{css}`
    css
  end

  def test_default_for_header
    assert_equal Less::More.header, true
  end

  def test_header_can_be_overwritten
    Less::More.header = false
    assert_equal false, Less::More.header
  end

  def test_default_for_source_path
    assert_equal 'app/stylesheets', Less::More.source_path
  end

  def test_source_path_can_be_overwritten
    Less::More.source_path = 'xxx'
    assert_equal 'xxx', Less::More.source_path
  end

  def test_default_for_destination_path
    assert_equal 'stylesheets', Less::More.destination_path
  end

  def test_destination_path_can_be_overwritten
    Less::More.destination_path = 'xxx'
    assert_equal 'xxx', Less::More.destination_path
  end

  def test_default_for_compression
    assert_equal nil, Less::More.compression
  end

  def test_compression_can_be_overwritten
    Less::More.compression = true
    assert_equal true, Less::More.compression
  end

  def test_generate_with_partials
    css_path = prepare_for_generate
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert css.include?(".allforms { font-size: 110%; }
body { color: #222222; }
form {
  font-size: 110%;
  color: #ffffff;
}")
  end

  def test_generate_does_not_parse_css
    css_path = prepare_for_generate
    Less::More.generate_all
    original_css = File.read(File.join(css_path, 'plain.css'))
    assert_equal File.read(File.join(Rails.root,'less_files', 'plain.css')), original_css
  end

  def test_generate_uses_header_when_set
    css_path = prepare_for_generate
    Less::More.header = true
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert_match /^\/\*/, css # starts with comment -> header
  end

  def test_generate_uses_no_header_when_not_set
    css_path = prepare_for_generate
    Less::More.header = false
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert_match /^\.allforms/, css
  end

  def test_generate_does_not_generate_partials
    css_path = prepare_for_generate
    Less::More.generate_all
    assert !File.exist?(File.join(css_path, '_global.css'))
  end
end