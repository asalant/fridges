# This file is used by Rack-based servers to start the application.

# Expire static assets in one year, Rails will cache bust with new deployments
$: << 'lib'
require 'rack_cache_headers'
use RackCacheHeaders, {
  %r(^/(stylesheets)|(javascripts)|(images)/) => {:cache_control => "max-age=15768000, public", :expires => 15768000}
}

require ::File.expand_path('../config/environment', __FILE__)
run Fridges::Application


