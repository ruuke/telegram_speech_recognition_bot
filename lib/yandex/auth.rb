# frozen_string_literal: true

module Yandex
  class Auth
    extend ResponseHandler

    class << self
      def access_token
        expired? ? refresh_token : @access_token
      end

      private

      def refresh_token
        response = Faraday.post('https://iam.api.cloud.yandex.net/iam/v1/tokens') do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end

        response_body = JSON.parse(handle_response(response).body)

        @expires_at = response_body['expiresAt']
        @access_token = response_body['iamToken']
      end

      def expired?
        return true if @expires_at.nil?

        Time.now > Time.parse(@expires_at)
      end

      def params
        {
          'yandexPassportOauthToken' => (ENV['YC_OAUTH_TOKEN']).to_s
        }
      end
    end
  end
end
