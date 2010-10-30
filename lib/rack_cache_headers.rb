# See http://www.hokstad.com/rack-middleware-adding-cache-headers.html
# Set cache control headers for Rack::File, configured in config.ru
class RackCacheHeaders
  def initialize(app, patterns)
    @app = app
    @patterns = patterns
    puts "Initialized RackCacheHeaders with #{patterns.inspect}"
  end

  def call(env)
    res = @app.call(env)
    path = env["PATH_INFO"]
    @patterns.each do |pattern, data|
      if path =~ pattern
        res[1]["Cache-Control"] = data[:cache_control] if data.has_key?(:cache_control)
        res[1]["Expires"] = (Time.now + data[:expires]).utc.rfc2822 if data.has_key?(:expires)
        return res
      end
    end
    res
  end
end