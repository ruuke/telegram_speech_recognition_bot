# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'json'
Dir['./**/*.rb'].sort.each { |file| require file }

Telegram::Bot::Client.run(ENV['TELEGRAM_API_KEY']) do |bot|
  bot.listen do |message|
    MessageHandler.call(message, bot)
  end
end
