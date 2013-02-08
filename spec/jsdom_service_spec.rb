require "spec_helper"

describe "JSDOMService" do
  def stub!(attributes = {})
    attributes[:endpoint] ||= "http://example.com"

    response_json = {
      error: attributes[:error] || nil,
      result: attributes[:result] || {},
    }.to_json

    stub_request(:post, attributes[:endpoint]).to_return(status: attributes[:status] || 200, body: response_json)
  end

  def go!(options = {})
    endpoint = options[:endpoint] || "http://example.com"
    html = options[:html] || "<h1>lol</h1>"
    code = options[:code] || ""
    JSDOMService.run(endpoint, html, code)
  end

  describe ".run" do
    it "makes a POST request to the JSDOM service endpoint" do
      endpoint_stub = stub!(endpoint: "http://example.com/endpoint")

      go!(endpoint: "http://example.com/endpoint")
      endpoint_stub.should have_been_requested
    end

    context "if the service responds with an error" do
      it "raises a JSDOMService::RequestException" do
        stub_request(:post, "http://example.com").to_raise(RestClient::Exception)

        expect { go! }.to raise_error(JSDOMService::RequestException)
      end
    end

    context "if the returned JSON includes an error" do
      it "raises a JSDOMService::ParseException" do
        stub!(error: {reason: "invalid html"})

        expect { go! }.to raise_error(JSDOMService::ParseException, "invalid html")
      end
    end

    context "if the service responds with 200 OK and no JSON error" do
      it "does not raise an exception" do
        stub!(status: 200, error: nil)

        expect { go! }.not_to raise_error
      end

      it "returns parsed JSON response" do
        stub!(:result => {'some' => 'json'})

        result = go!
        result.should == {'some' => 'json'}
      end
    end
  end
end
