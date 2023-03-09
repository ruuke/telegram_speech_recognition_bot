# frozen_string_literal: true

module Yandex
  class SpeechRecognize
    extend ResponseHandler

    class << self
      def call(voice_file)
        response = connection.post do |req|
          req.body = voice_file
        end

        handle_response(response).body.split('"')[3]
      end

      private

      def connection
        conn = Faraday.new(
          url: 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize',
          params: {
            folderId: ENV['YC_FOLDER_ID'],
            lang: 'ru-RU'
          },
          headers: {
            'Content-Type' => 'audio/ogg',
            'Authorization' => "Bearer #{ENV['YC_IAM_TOKEN']}"
          }
        )
      end
    end
  end
end
