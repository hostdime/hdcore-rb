require 'hdcore/version'
require 'httparty'
require 'logger'
require 'yaml'
require 'json'
require 'digest/sha2'  # to generate SHA256 hash
require 'securerandom' # to generate v4 UUID

Dir[File.dirname(__FILE__) + '/hdcore/*.rb'].each do |file|
  require file
end
