require "sinatra/base"
require "semantic_logger"
require_relative "pkg_lookup"

SemanticLogger.add_appender(io: $stdout, formatter: :color)

class Server < Sinatra::Base
  set :port, (ENV["GOLANG_LATEST_PORT"] || 50005).to_i
  enable :logging
  disable :show_exceptions

  def pkg_lookup
    @pkg_lookup ||= PkgLookup.new
  end

  get "/golang/checksum/:platform" do
    checksum = pkg_lookup.lookup.checksums[params["platform"]]
    if checksum.nil?
      404
    else
      checksum
    end
  end

  get "/golang/dl/:platform" do
    version = pkg_lookup.lookup.version
    platform = params["platform"]
    redirect "https://go.dev/dl/#{version}.#{platform}.tar.gz", 303
  end

  not_found do
    "404..."
  end

  error do
    "error state..."
  end
end
