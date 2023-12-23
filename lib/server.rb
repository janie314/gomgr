require "sinatra/base"
require "semantic_logger"

SemanticLogger.add_appender(io: $stdout, formatter: :color)

class Server < Sinatra::Base
  set :port, (ENV["GOLANG_LATEST_PORT"] || 50005).to_i
  enable :logging

  get "/golang/" do
    redirect "https://go.dev/", 303
  end

  not_found do
    "404..."
  end

  error do
    "error state..."
  end
end
