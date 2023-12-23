require "faraday"
require "rufus-scheduler"
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
      if res.length == 0
        l.error "blank golist..."
      else
        @lookup = {
          "version" => res[0]["version"],
          "checksums" => (res[0]["files"].map do |entry|
            [entry["os"] + "-" + entry["arch"], entry["sha256"]]
          end).to_h
        }
        puts @lookup
      end
    else
      l.error "invalid schema from go.dev query"
    end
  end

  def initialize
    update
    Rufus::Scheduler.new.cron "30 0 * * *" do update end
  end
end
