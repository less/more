class ActionController::Base
  before_filter :generate_css_from_less

  def generate_css_from_less
    Less::More.generate_all
  end
end