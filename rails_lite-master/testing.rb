require 'webrick'
require 'uri'

def parse_www_encoded_form(www_encoded_form)
  hash = {}
  URI.decode_www_form(www_encoded_form).each do |pair|
    keys = pair[0].split(/\]\[|\[|\]/) << pair[1]
    hash[keys.shift] = keys.reverse.inject {|k,r| {r => k} }
end
