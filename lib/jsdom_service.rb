require "rest_client"
require "json"

module JSDOMService
  module_function

  def run(endpoint, html, code)
    raw_json = RestClient.post(endpoint, {html: html, code: code})
    json = JSON.parse(raw_json)
    json['result']
  end
end
