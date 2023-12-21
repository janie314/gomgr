require "faraday"
require "pry-byebug"

class GolangLatest
  def self.query_versions
    @query_versions ||= Faraday.new(url: "https://go.dev/dl/",
      params: {mode: "json"}) do |f|
      f.response :json
      f.response :raise_error
      f.response :logger
    end
  end

  def self.update
    res = query_versions.get.body
  end
end

GolangLatest.update
