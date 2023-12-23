require "sinatra/base"
require "semantic_logger"

SemanticLogger.add_appender(io: $stdout, formatter: :color)

get "/golang" do
  "hootenanny"
end
