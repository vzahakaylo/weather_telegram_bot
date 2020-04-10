require 'telegram/bot'
require_relative 'weather'
class TelegramBot
  TOKEN = '1155350159:AAF5Jy0T_LO5wHKCUyxaVQGtEGWsKfTu7aI'.freeze

  def run
    # bot.listen do |message|
    #   case message.text
    #   when '/start'
    #     question = 'London is a capital of which country?'
    #     # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    #     answers =
    #         Telegram::Bot::Types::ReplyKeyboardMarkup
    #             .new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
    #     bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
    #   when '/stop'
    #     # See more: https://core.telegram.org/bots/api#replykeyboardremove
    #     kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    #     bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
    #   end
    # end

    bot.listen do |message|
      weather_message(message)
    rescue => e
      puts e.message
    end
  end

  private

  def bot
    Telegram::Bot::Client.run(TOKEN) { |bot| return bot }
  end

  def weather_message(message)
    return unless message.text.include? '/weather'

    send_message(message.chat.id, Weather.new(city_name(message.text)).form_message)
  end

  def city_name(text)
    text.gsub('/weather', '').strip.tr(' ', '+')
  end

  def send_message(chat_id, message)
    bot.api.sendMessage(chat_id: chat_id, text: message)
  end
end