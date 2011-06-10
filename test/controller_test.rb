require 'test_helper'

class ExampleController < ActionController::Base
  def test
    render :text => 'OK'
  end
end

class ControllerTest < ActionController::TestCase
  def setup
    @controller = ExampleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_for_generate_test
  end

  def teardown
    teardown_for_generate_test
  end

  should "generate less files" do
    write_less 'xxx.less', 'a{color:red}'
    get :test
    assert_equal 'a { color: red; }', read_css('xxx.css').strip
  end
end
