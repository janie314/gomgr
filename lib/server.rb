require "sinatra/base"
require "semantic_logger"

SemanticLogger.add_appender(io: $stdout, formatter: :color)

class Server < Sinatra::Base
  get "/golang" do
    "hootenanny"
  end
end
