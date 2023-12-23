require "json_schemer"

class Schema
  def self.query_versions
    @query_versions ||= JSONSchemer.schema({
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "title" => "Generated schema for Root",
      "type" => "array",
      "items" => {
        "type" => "object",
        "properties" =>
 {
   "version" => {"type" => "string"},
   "stable" => {"type" => "boolean"},
   "files" =>
   {
     "type" => "array",
     "items" =>
     {
       "type" => "object",
       "properties" =>
       {
         "filename" => {"type" => "string"},
         "os" => {"type" => "string"},
         "arch" => {"type" => "string"},
         "version" => {"type" => "string"},
         "sha256" => {"type" => "string"},
         "size" => {"type" => "number"},
         "kind" => {"type" => "string"}
       },
       "required" => ["filename", "os", "arch", "version", "sha256", "size", "kind"]
     }
   }
 },
        "required" => ["version", "stable", "files"]
      }
    })
  end
end
