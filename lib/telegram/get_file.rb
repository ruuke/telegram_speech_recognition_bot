module Telegram
  class GetFile
    extend ResponseHandler

    def self.call(file_path)
      file_url = "https://api.telegram.org/file/bot#{ENV['TELEGRAM_API_KEY']}/#{file_path}"
      response = Faraday.get(file_url)
      handle_response(response)
    end
  end
end
