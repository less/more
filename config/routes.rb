ActionController::Routing::Routes.draw do |map|
  map.connect 'stylesheets/*id.css', :controller => 'less_cache', :action => "show"
end