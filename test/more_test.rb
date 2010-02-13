require 'test_helper'

class MoreTest < ActiveSupport::TestCase
  def setup
    [:compression, :header, :destination_path, :source_path].each do |variable|
      Less::More.send("#{variable}=", nil)
    end
  end

  def teardown
    `rm -rf #{css_path}`
  end

  def prepare_for_generate
    Less::More.source_path = 'less_files'
    Less::More.destination_path = 'css'

    `rm -rf #{css_path}`
    `mkdir -p #{css_path}`
  end

  def css_path
    "#{Rails.root}/public/css"
  end

  test "header is true by default" do
    assert_equal Less::More.header, true
  end

  test "header can be overwritten" do
    Less::More.header = false
    assert_equal false, Less::More.header
  end

  test "source_path is app/stylesheets by default" do
    assert_equal 'app/stylesheets', Less::More.source_path
  end

  test "source_path can be overwritten" do
    Less::More.source_path = 'xxx'
    assert_equal 'xxx', Less::More.source_path
  end

  test "destination_path is public/stylesheets by default" do
    assert_equal 'stylesheets', Less::More.destination_path
  end

  test "destination_path can be overwritten" do
    Less::More.destination_path = 'xxx'
    assert_equal 'xxx', Less::More.destination_path
  end

  test "compression is off by default" do
    assert_equal nil, Less::More.compression
  end

  test "compression can be overwritten" do
    Less::More.compression = true
    assert_equal true, Less::More.compression
  end

  test "generate includes imported partials" do
    prepare_for_generate
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert css.include?(".allforms { font-size: 110%; }
body { color: #222222; }
form {
  font-size: 110%;
  color: #ffffff;
}")
  end

  test "generate does not parse css" do
    prepare_for_generate
    Less::More.generate_all
    original_css = File.read(File.join(css_path, 'plain.css'))
    assert_equal File.read(File.join(Rails.root,'less_files', 'plain.css')), original_css
  end

  test "generate adds disclaimer-header when active" do
    prepare_for_generate
    Less::More.header = true
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert_match /^\/\*/, css # starts with comment -> header
  end

  test "generate uses no header when not set" do
    prepare_for_generate
    Less::More.header = false
    Less::More.generate_all
    css = File.read(File.join(css_path, 'test.css'))
    assert_match /^\.allforms/, css
  end

  test "generate does not generate partials" do
    prepare_for_generate
    Less::More.generate_all
    assert !File.exist?(File.join(css_path, '_global.css'))
  end
end