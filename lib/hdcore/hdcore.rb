#
module Hdcore
  @log = Logger.new(STDOUT)

  # Default configuration values
  @config = {
              :api_endpoint => 'https://api.hostdime.com/v1',
              :public_key   => nil,
              :private_key  => nil,
              :time_zone    => 'US/Eastern'
            }
  @valid_config_keys = @config.keys

  class << self
    # Configure HDCore with an options hash.
    # @param [Hash] opts Configuration options hash
    # @option opts [String] :api_endpoint ('core.hostdime.com/api/v1') The HDCore API endpoint URI
    # @option opts [String] :public_key Your HDCore public key
    # @option opts [String] :private_key Your HDCore private key
    def configure opts = {}
      opts.each do |key, val|
        config[key.to_sym] = val if @valid_config_keys.include? key.to_sym
      end
    end

    # Configure HDCore with an external yaml config file.
    # @param [String] path_to_yaml_file Absolute path to yaml config file
    def configure_with path_to_yaml_file
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        log.warn "YAML config file not found: using defaults instead"; return
      rescue Psych::SyntaxError
        log.warn "YAML config file has invalid syntax: using defaults instead"; return
      end

      configure(config)
    end

    # Current configuration hash
    def config
      @config
    end

    # For logging purposes
    def log
      @log
    end

    # @return [Bool] True if there are configuration keys that have no assigned value.
    def missing_config_values?
      config.values.include? nil
    end

    # @return [Array] Configuration keys that have no assigned value.
    def missing_config_values
      config.select{|k,v| v.nil?}.keys
    end
  end

end