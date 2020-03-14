# frozen_string_literal: true

require 'http'

require 'ebay/config'

module Ebay
  module Oauth
    # Mints an access token to use in API requests
    #
    # @see https://developer.ebay.com/api-docs/static/oauth-client-credentials-grant.html
    class ClientCredentialsGrant
      URL = 'https://api.ebay.com/identity/v1/oauth2/token'

      # @return [String]
      attr_reader :app_id

      # @return [String]
      attr_reader :cert_id

      # @param [String] app_id
      # @param [String] cert_id
      def initialize(app_id: Config.app_id, cert_id: Config.cert_id)
        @app_id = app_id
        @cert_id = cert_id
      end

      # Mints a new access token
      #
      # @return [String]
      def mint_access_token
        JSON.parse(request).fetch('access_token')
      end

      # Requests a client credentials grant
      #
      # @return [HTTP::Response]
      def request
        HTTP.basic_auth(user: app_id, pass: cert_id)
            .post(url, form: payload)
      end

      # Runs the request in the eBay sandbox environment
      def sandbox
        @url = URL.sub('ebay', 'sandbox.ebay')
        self
      end

      private

      # The endpoint URL
      # @return [String]
      def url
        @url ||= URL
      end

      def payload
        { grant_type: 'client_credentials',
          scope: 'https://api.ebay.com/oauth/api_scope' }
      end
    end
  end
end
