require "httpi/response"

module HTTPI
  module Adapter

    # = HTTPI::Adapter::HTTPClient
    #
    # Adapter for the HTTPClient client.
    # http://rubygems.org/gems/httpclient
    class HTTPClient

      # Requires the "httpclient" gem.
      def initialize(request = nil)
        require "httpclient"
      end

      # Returns a memoized <tt>HTTPClient</tt> instance.
      def client
        @client ||= ::HTTPClient.new
      end

      # Executes an HTTP GET request.
      # @see HTTPI.get
      def get(request)
        do_request request do |client, url, headers|
          client.get url, nil, headers
        end
      end

      # Executes an HTTP POST request.
      # @see HTTPI.post
      def post(request)
        do_request request do |client, url, headers, body|
          client.post url, body, headers
        end
      end

      # Executes an HTTP HEAD request.
      # @see HTTPI.head
      def head(request)
        do_request request do |client, url, headers|
          client.head url, nil, headers
        end
      end

      # Executes an HTTP PUT request.
      # @see HTTPI.put
      def put(request)
        do_request request do |client, url, headers, body|
          client.put url, body, headers
        end
      end

      # Executes an HTTP DELETE request.
      # @see HTTPI.delete
      def delete(request)
        do_request request do |client, url, headers|
          client.delete url, headers
        end
      end
    private

      def do_request(request)
        setup_client request
        respond_with yield(client, request.url, request.headers, request.body)
      end

      def setup_client(request)
        basic_setup request
        auth_setup request if request.auth?
      end

      def basic_setup(request)
        client.proxy = request.proxy if request.proxy
        client.connect_timeout = request.open_timeout
        client.receive_timeout = request.read_timeout
      end

      def auth_setup(request)
        client.set_auth request.url.to_s, *request.credentials
      end

      def respond_with(response)
        Response.new response.code, Hash[response.header.all], response.content
      end

    end
  end
end
