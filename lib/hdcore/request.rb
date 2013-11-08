#
module Hdcore
  class Request
    include HTTParty

    class << self

      # @param [String] action The full API action
      # @param [Hash] params The given action parameters
      # @return [HTTParty::Response]
      def call(action, params = {})
        init()
        self.post("/#{action.gsub('.','/')}.json", query_string(action, params))
      end

      private

      # @private
      # Initializes the request: throws exception if there are configs missing (requires public and private keys)
      def init
        # Make sure required config values are set
        if Hdcore.missing_config_values?
          msg = "Hdcore is not yet properly configured: Missing #{Hdcore.missing_config_values}"

          Hdcore.log.error(msg)
          raise Exception, msg, caller
        end

        # set base uri for HTTParty request
        base_uri Hdcore.config[:api_endpoint]
      end

      # @private
      # @return [String] public key established in configuration
      def public_key
        Hdcore.config[:public_key]
      end

      # @private
      # @return [String] private key established in configuration
      def private_key
        Hdcore.config[:private_key]
      end

      # @private
      # @param [String] action The full API action
      # @param [Hash] params The given action parameters
      # @return [Hash] Full set of parameters, including generated api parameters
      def query_string(action, params = {})
        params.merge generate_api_params(action, params)
      end

      # @private
      # @param [String] action The full API action
      # @param [Hash] action_params The given action parameters
      # @return [Hash] required api parameters: {:api_key, :api_unique, :api_timestamp, :api_hash}
      def generate_api_params(action, params = {})
        {
          :api_key       => public_key,
          :api_unique    => uuid = generate_uuid,
          :api_timestamp => timestamp = Time.now.to_i,
          :api_hash      => generate_hash( timestamp,
                                           uuid,
                                           private_key,
                                           action,
                                           params.to_json )
        }
      end

      # @private
      # @return [String] SHA256 hash of all the arguments "joined:with:colons"
      def generate_hash(*args)
        (Digest::SHA2.new << args.join(':')).to_s
      end

      # @private
      # @return [String] Version 4 UUID
      # More: http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29
      def generate_uuid
        SecureRandom.uuid
      end
    end

  end
end
