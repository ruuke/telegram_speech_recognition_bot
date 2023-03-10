# frozen_string_literal: true

module Yandex
  class SpeechRecognize
    extend ResponseHandler

    class << self
      def call(voice_file)
        response = connection.post do |req|
          req.body = voice_file
        end

        JSON.parse(handle_response(response).body)['result']
      end

      private

      def connection
        Faraday.new(
          url: 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize',
          params: {
            folderId: ENV['YC_FOLDER_ID'],
            lang: 'ru-RU'
          },
          headers: {
            'Content-Type' => 'audio/ogg',
            'Authorization' => "Bearer #{Auth.access_token}"
          }
        )
      end
    end
  end
end
