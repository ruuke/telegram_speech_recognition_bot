# frozen_string_literal: true

class MessageHandler
  def self.call(message, bot)
    if message.voice
      file_path = bot.api.get_file(file_id: message.voice.file_id).dig('result', 'file_path')

      voice_file_response = Telegram::GetFile.call(file_path)

      recognized_text = Yandex::SpeechRecognize.call(voice_file_response.body)

      bot.api.send_message(chat_id: message.chat.id, text: recognized_text)
    else
      bot.api.send_message(chat_id: message.chat.id,
                           text: 'Please send voice message and I will translate it into text message.')
    end
  rescue StandardError => e; puts e
  end
end
