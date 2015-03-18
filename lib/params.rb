class Params
  def initialize(req, route_params = {})
    @attributes = route_params

    queries = []
    queries += req.query_string.split('&') if req.query_string
    queries += req.body.split('&') if req.body
    queries.each do |query|
      hash = parse_query(query)
      @attributes.deep_merge!(hash)
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

end
