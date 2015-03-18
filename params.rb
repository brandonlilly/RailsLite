require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @attributes = route_params

      queries = []
      queries += req.query_string.split('&') if req.query_string
      queries += req.body.split('&') if req.body
      queries.each do |query|
        hash = parse_query(query)
        @attributes.merge!(hash)
      end
    end

    def [](key)
      @attributes[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    # key=value
    #  => { key => value }
    # user[address][street]=value
    #  => { user => { address => { street => value}}}
    def parse_query(query)
      keys, value = query.split('=')
      keys = keys.scan(/\w+/)
      pair_to_hash(keys, value)
    end

    def pair_to_hash(keys, value)
      return { keys.first => value } if keys.size == 1
      { keys.first => pair_to_hash(keys.drop(1), value) }
    end

    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)

    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
    end
  end
end
