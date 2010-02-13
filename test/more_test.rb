require 'test_helper'

class MoreTest < ActiveSupport::TestCase
  setup do
    [:compression, :header, :destination_path, :source_path].each do |variable|
      Less::More.send("#{variable}=", nil)
    end
  end

  context :header do
    should "be true by default" do
      assert_equal Less::More.header, true
    end

    should "be overwriteable" do
      Less::More.header = false
      assert_equal false, Less::More.header
    end
  end

  context :source_path do
    should "be app/stylesheets by default" do
      assert_equal 'app/stylesheets', Less::More.source_path
    end

    should "be overwritteable" do
      Less::More.source_path = 'xxx'
      assert_equal 'xxx', Less::More.source_path
    end
  end

  context :destination_path do
    should "be public/stylesheets by default" do
      assert_equal 'stylesheets', Less::More.destination_path
    end

    should "be overwritteable" do
      Less::More.destination_path = 'xxx'
      assert_equal 'xxx', Less::More.destination_path
    end
  end

  context :compression do
    should "be off by default" do
      assert_equal nil, Less::More.compression
    end

    should "be overwritteable" do
      Less::More.compression = true
      assert_equal true, Less::More.compression
    end
  end

  def css_path
    "#{Rails.root}/public/css"
  end

  context :generate do
    setup do
      Less::More.source_path = 'less_files'
      Less::More.destination_path = 'css'
      `mkdir -p #{css_path}`
    end

    teardown do
      `rm -rf #{css_path}`
    end

    should "include imported partials" do
      Less::More.generate_all
      css = File.read(File.join(css_path, 'test.css'))
      assert css.include?(".allforms { font-size: 110%; }
body { color: #222222; }
form {
  font-size: 110%;
  color: #ffffff;
}")
    end

    should "not parse css" do
      Less::More.generate_all
      original_css = File.read(File.join(css_path, 'plain.css'))
      assert_equal File.read(File.join(Rails.root,'less_files', 'plain.css')), original_css
    end

    should "add disclaimer-header when active" do
      Less::More.header = true
      Less::More.generate_all
      css = File.read(File.join(css_path, 'test.css'))
      assert_match /^\/\*/, css # starts with comment -> header
    end

    should "not include header when not set" do
      Less::More.header = false
      Less::More.generate_all
      css = File.read(File.join(css_path, 'test.css'))
      assert_match /^\.allforms/, css
    end

    should "not generate partials" do
      Less::More.generate_all
      assert !File.exist?(File.join(css_path, '_global.css'))
    end
  end
end