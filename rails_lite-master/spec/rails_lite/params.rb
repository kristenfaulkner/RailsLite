require 'debugger'
require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = route_params
    if req.query_string
      @params.update(parse_www_encoded_form(req.query_string))
    end
    if req.body
      @params.update(parse_www_encoded_form(req.body))
    end
    @permitted_keys = []
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
    @permitted_keys += keys
  end
  
  def require(key)
    raise AttributeNotFoundError.new unless @params.has_key?(key) #&& permitted?(key)
  end

  def permitted?(key)
    @permitted_keys.include? key
  end

  def to_s
    @params.to_json
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  def parse_www_encoded_form(www_encoded_form)
    hash = {}
    URI.decode_www_form(www_encoded_form).each do |pair|
      keys = pair[0].split(/\]\[|\[|\]/) << pair[1]
      hash[keys.shift] = keys.reverse.inject {|k,r| {r => k} }
    end
    hash
  end
end
