require "faraday"
require_relative "../lib/schema"

class PkgLookup
  def l
    @l ||= SemanticLogger["package lookup"]
  end

  def lookup
    @lookup ||= {}
  end

  def query_versions
    @query_versions ||= Faraday.new(url: "https://go.dev/dl/",
      params: {mode: "json"}) do |f|
      f.response :json
      f.response :raise_error
      f.response :logger
    end
  end

  def update
    res = query_versions.get.body
    if Schema.query_versions.valid? res
      @lookup = res
    else
      l.error "invalid schema from go.dev query"
    end
  end
end
