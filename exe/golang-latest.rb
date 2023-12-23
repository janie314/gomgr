require "faraday"
require "pry-byebug"
require_relative "../lib/schema"

class GolangLatest
  def self.index
    @index ||= {}
  end

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
    puts "v", (Schema.query_versions.valid? res)
  end
end

GolangLatest.update
