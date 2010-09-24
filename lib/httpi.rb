require "httpi/version"
require "httpi/request"
require "httpi/adapter"

# = HTTPI
#
# Executes HTTP requests using a predefined adapter.
module HTTPI
  class << self

    # Executes an HTTP GET request and returns an <tt>HTTPI::Response</tt>.
    #
    # ==== Example
    #
    # Accepts an <tt>HTTPI::Request</tt> and an optional adapter:
    #
    #   request = HTTPI::Request.new :url => "http://example.com"
    #   HTTPI.get request, :httpclient
    #
    # ==== Shortcut
    #
    # You can also just pass a URL and an optional adapter if you don't
    # need to configure the request:
    #
    #   HTTPI.get "http://example.com", :curb
    #
    # ==== More control
    #
    # If you need more control over the request, you can access the HTTP
    # client instance represented by your adapter in a block.
    #
    #   HTTPI.get request do |http|
    #     http.follow_redirect_count = 3  # HTTPClient example
    #   end
    def get(request, adapter = nil)
      request = Request.new :url => request if request.kind_of? String
      
      with adapter do |adapter|
        yield adapter.client if block_given?
        adapter.get request
      end
    end

    # Executes an HTTP POST request and returns an <tt>HTTPI::Response</tt>.
    #
    # ==== Example
    #
    # Accepts an <tt>HTTPI::Request</tt> and an optional adapter:
    #
    #   request = HTTPI::Request.new
    #   request.url = "http://example.com"
    #   request.body = "<some>xml</some>"
    #   
    #   HTTPI.post request, :httpclient
    #
    # ==== Shortcut
    #
    # You can also just pass a URL, a request body and an optional adapter
    # if you don't need to configure the request:
    #
    #   HTTPI.post "http://example.com", "<some>xml</some>", :curb
    #
    # ==== More control
    #
    # If you need more control over the request, you can access the HTTP
    # client instance represented by your adapter in a block.
    #
    #   HTTPI.post request do |http|
    #     http.use_ssl = true  # Curb example
    #   end
    def post(*args)
      request, adapter = request_and_adapter_from(args)
      
      with adapter do |adapter|
        yield adapter.client if block_given?
        adapter.post request
      end
    end

    # Executes an HTTP PUT request and returns an <tt>HTTPI::Response</tt>.
    #
    # ==== Example
    #
    # Accepts an <tt>HTTPI::Request</tt> and an optional adapter:
    #
    #   request = HTTPI::Request.new
    #   request.url = "http://example.com"
    #   request.body = "<some>xml</some>"
    #   
    #   HTTPI.put request, :httpclient
    #
    # ==== Shortcut
    #
    # You can also just pass a URL, a request body and an optional adapter
    # if you don't need to configure the request:
    #
    #   HTTPI.put "http://example.com", "<some>xml</some>", :curb
    #
    # ==== More control
    #
    # If you need more control over the request, you can access the HTTP
    # client instance represented by your adapter in a block.
    #
    #   HTTPI.put request do |http|
    #     http.use_ssl = true  # Curb example
    #   end
    def put(*args)
      request, adapter = request_and_adapter_from(args)
      
      with adapter do |adapter|
        yield adapter.client if block_given?
        adapter.put request
      end
    end

    private

    # Checks whether +args+ contains of an <tt>HTTPI::Request</tt> or a URL
    # and a request body plus an optional adapter and returns an Array with
    # an <tt>HTTPI::Request</tt> and (if given) an adapter.
    def request_and_adapter_from(args)
      return args if args[0].kind_of? Request
      [Request.new(:url => args[0], :body => args[1]), args[2]]
    end

    # Accepts an +adapter+ (defaults to <tt>Adapter.use</tt>) and yields a
    # new instance of the adapter to a given block.
    def with(adapter)
      adapter ||= Adapter.use
      yield Adapter.find(adapter).new
    end

  end
end
