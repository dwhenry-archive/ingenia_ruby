
require 'restclient'
require 'json'

require 'ostruct'

require 'nowa_api/remote'
require 'nowa_api/item'
require 'nowa_api/tag'
require 'nowa_api/tag_set'
require 'nowa_api/bundle'

module Nowa
  module Api

    extend self
    
    class CallFailed < StandardError
      def initialize(output)
        prefix = output['status']
        message = output['message']
        super "#{prefix}: #{message}"
      end
    end

    # Status of your app
    def status
      debug { "status" }
      verify_response { Remote.get('/status', :api_key => api_key ) }
    end

    # Classify some text
    def classify(text)
      debug { "classify" }
      verify_response { Remote.post('/classify', :api_key => api_key, :text => text) }
    end

    # Deprecated train action, now creates an item
    def train(text, tags = {})
      debug { "train" }
      if tags.is_a? Array
        Item.create(:text => text, :tags => tags)

      elsif tags.is_a? Hash
        Item.create(:text => text, :tag_sets => tags)

      else
        raise "Nowa::Api.train(text, tags) must be called with tags argument as either an Array or a Hash"
      end
    end

    # Find similar items
    def similar_to(item_id, limit = 10)
      debug { "similar_to" }
      verify_response { Remote.get("/similar_to/#{item_id}", :api_key => api_key, :limit => limit ) }
    end

    # Summarize some text
    def summarize(params = {})
      debug { "summarize" }
      initialize_params params    

      verify_response { Remote.post("/summarise", @params ) }
    end

    def trained_tags
      debug { "trained_tags" }
      verify_response { Remote.get('/learnt_tags', :api_key => api_key) }
    end
    
    def endpoint=(ep)
      debug { "endpoint=#{Remote.endpoint}" }
      Remote.endpoint = ep
    end

    def api_key=(k)
      debug { "api_key=#{k}" }
      @api_key = k
    end

    def api_key
      raise 'Nowa::Api.api_key not set' if @api_key.nil?
      @api_key
    end

    def debug=(dbg)
      @debug = dbg
      debug { "debug is on" }
    end

    def verify_response
      output = yield
      
      puts output

      return output['data'] if output['status'] == 'okay'

      raise CallFailed.new( output )
    end

    private

      def initialize_params( params = {} )
        # break params down into for json object and for request
        request_params = params

        @params = { :api_key => Nowa::Api.api_key }
        @params.merge! request_params
      end

      def debug
        puts "Nowa::Api.debug: #{yield}" if @debug
      end

  end
end
