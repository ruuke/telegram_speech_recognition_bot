require 'telegram/bot'
require 'dotenv/load'
require "open-uri"

Telegram::Bot::Client.run(ENV['TELEGRAM_API_KEY']) do |bot|
  bot.listen do |message|
    if message.voice
      file_path = bot.api.get_file(file_id: message.voice.file_id).dig('result', 'file_path')

      file_url = "https://api.telegram.org/file/bot#{ENV['TELEGRAM_API_KEY']}/#{file_path}"
      response_ogg = Faraday.get(file_url)

      conn = Faraday.new(
        url: 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize',
        params: { folderId: 'b1gm3dllrbi3q5sk14m8', lang: 'ru-RU' },
        headers: {'Content-Type' => 'audio/ogg', 'Authorization' => "Bearer #{ENV['YC_IAM_TOKEN']}"}
      )

      response = conn.post do |req|
        req.params['limit'] = 100
        req.body = response_ogg.body
      end

      puts response.body.class
      puts response.body['result']
      puts response.body

      bot.api.send_message(chat_id: message.chat.id, text: response.body.split('"')[3])
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'Unknown type')
    end
    rescue StandardError => e; puts e
  end
end
