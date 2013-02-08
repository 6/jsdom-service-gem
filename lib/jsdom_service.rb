require "rest_client"
require "json"

module JSDOMService
  module_function

  def run(endpoint, html, code)
    raw_json = RestClient.post(endpoint, {html: html, code: code})
    json = JSON.parse(raw_json)
    if error = json['error']
      raise ParseException.new(error['reason'])
    end
    json['result']
  rescue RestClient::Exception
    raise RequestException
  end
end

module JSDOMService
  class JSDOMServiceError < StandardError
    def initialize(*args)
      super
    end
  end

  class RequestException < JSDOMServiceError
  end

  class ParseException < JSDOMServiceError
    def initialize(*args)
      super
    end
  end
end
